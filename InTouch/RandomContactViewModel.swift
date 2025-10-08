import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class RandomContactViewModel {
    private let fetcher = ContactFetcher()
    private let analytics = ContactAnalytics.shared

    // Contacts and selection bag
    private(set) var contacts: [ContactRecord] = []
    private var remaining: [String] = []

    // Exclusions & history
    private(set) var excludedIDs: Set<String> = []
    private(set) var seenIDs: Set<String> = []

    // Settings
    var noRepeatsEver = false

    // UI state
    var current: ContactRecord?
    var statusMessage: String?
    var isLoading = false

    // Persistence
    private let defaults = UserDefaults.standard
    private let remainingKey = "remainingContactIDs_v2"
    private let excludedKey  = "excludedContactIDs_v1"
    private let seenKey      = "seenContactIDs_v1"
    private let noRepeatsKey = "noRepeatsEver_v1"

    // Bootstrap (UI-safe): do permission on main, heavy fetch off main via fetcher.loadContacts()
    @MainActor
    func bootstrap() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await fetcher.requestAccessIfNeeded()
            // Load contacts off the main thread
            let loaded = try await fetcher.loadContacts()
            // Update state back on the main actor
            contacts = loaded
            loadPersistedState()
            scrubInvalidIDs()
            rebuildRemainingIfNeeded()
            // Don't auto-spin - let user tap the button
        } catch ContactFetcher.FetchError.unauthorized {
            statusMessage = "Please allow Contacts access in Settings to use the app."
        } catch ContactFetcher.FetchError.noContacts {
            statusMessage = "No contacts with phone numbers were found."
        } catch {
            statusMessage = "Something went wrong: \(error.localizedDescription)"
        }
    }

    // Spin logic
    @MainActor
    func spin() {
        statusMessage = nil
        let eligible = eligibleIDs()
        guard !eligible.isEmpty else {
            current = nil
            remaining = []
            persistRemaining()
            statusMessage = "No eligible contacts. Check exclusions or turn off No Repeats."
            return
        }

        if remaining.isEmpty {
            remaining = eligible.shuffled()
            persistRemaining()
        }

        guard let nextId = remaining.popLast() else { return }
        persistRemaining()

        if let next = contacts.first(where: { $0.id == nextId }) {
            current = next
            
            // Track spin analytics
            analytics.recordContact(next.id, name: next.fullName, type: .spin)
            
            if noRepeatsEver {
                seenIDs.insert(nextId)
                persistSeen()
            }
        } else {
            spin()
        }
    }

    // Primary phone (already pre-sorted in fetcher)
    func primaryPhone(for c: ContactRecord?) -> LabeledPhone? { c?.phones.first }

    // Actions
    @MainActor
    func call(number: String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
            // Track analytics
            if let contact = current {
                analytics.recordContact(contact.id, name: contact.fullName, type: .call)
            }
        }
    }
    @MainActor
    func textFallbackURL(number: String) {
        if let url = URL(string: "sms:\(number)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            
            // Track analytics
            if let contact = current {
                analytics.recordContact(contact.id, name: contact.fullName, type: .text)
            }
        }
    }

    @MainActor
    func excludeCurrent() {
        guard let id = current?.id else { return }
        excludedIDs.insert(id)
        remaining.removeAll { $0 == id }
        persistExcluded()
        persistRemaining()
        current = nil
        spin()
    }

    @MainActor
    func restore(id: String) {
        excludedIDs.remove(id)
        persistExcluded()
        rebuildRemainingIfNeeded()
    }
    @MainActor
    func restoreAll() {
        excludedIDs.removeAll()
        persistExcluded()
        rebuildRemainingIfNeeded()
    }
    @MainActor
    func clearSeenHistory() {
        seenIDs.removeAll()
        persistSeen()
        rebuildRemainingIfNeeded()
    }

    // Helpers
    func excludedContacts() -> [ContactRecord] {
        contacts.filter { excludedIDs.contains($0.id) }
            .sorted { $0.fullName < $1.fullName }
    }
    private func eligibleIDs() -> [String] {
        var base = Set(contacts.map { $0.id })
        base.subtract(excludedIDs)
        if noRepeatsEver { base.subtract(seenIDs) }
        return Array(base)
    }
    private func rebuildRemainingIfNeeded() {
        let eligible = Set(eligibleIDs())
        let stillValid = remaining.filter { eligible.contains($0) }
        if stillValid.count != remaining.count || remaining.isEmpty {
            remaining = Array(eligible).shuffled()
            persistRemaining()
        }
    }
    private func scrubInvalidIDs() {
        let valid = Set(contacts.map { $0.id })
        excludedIDs = excludedIDs.filter { valid.contains($0) }
        seenIDs     = seenIDs.filter { valid.contains($0) }
        remaining   = remaining.filter { valid.contains($0) }
        persistExcluded(); persistSeen(); persistRemaining()
    }

    private func loadPersistedState() {
        if let a = defaults.array(forKey: remainingKey) as? [String] { remaining = a }
        if let a = defaults.array(forKey: excludedKey)  as? [String] { excludedIDs = Set(a) }
        if let a = defaults.array(forKey: seenKey)      as? [String] { seenIDs = Set(a) }
        noRepeatsEver = defaults.bool(forKey: noRepeatsKey)
    }

    private func persistRemaining() { defaults.set(remaining, forKey: remainingKey) }
    private func persistExcluded()  { defaults.set(Array(excludedIDs), forKey: excludedKey) }
    private func persistSeen()      { defaults.set(Array(seenIDs), forKey: seenKey) }

    // Settings deep link
    @MainActor
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    func setNoRepeatsEver(_ on: Bool) {
        noRepeatsEver = on
        defaults.set(on, forKey: noRepeatsKey)
        rebuildRemainingIfNeeded()
    }
}

