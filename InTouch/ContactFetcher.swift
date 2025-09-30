import Foundation
import UIKit
@preconcurrency import Contacts   // silence legacy Sendable warnings from the Contacts module

final class ContactFetcher {
    // Use this store only for permission prompts on the main actor.
    private let authStore = CNContactStore()

    enum FetchError: Error {
        case unauthorized
        case noContacts
    }

    // Ask for Contacts permission (safe to call on main)
    func requestAccessIfNeeded() async throws {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .notDetermined {
            let granted = try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Bool, Error>) in
                authStore.requestAccess(for: .contacts) { ok, err in
                    if let err = err { cont.resume(throwing: err); return }
                    cont.resume(returning: ok)
                }
            }
            guard granted else { throw FetchError.unauthorized }
        } else if status != .authorized {
            throw FetchError.unauthorized
        }
    }

    // Async wrapper: do the heavy enumerate off the main thread WITHOUT capturing CNContactStore
    func loadContacts() async throws -> [ContactRecord] {
        try await withCheckedThrowingContinuation { cont in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let results = try Self.loadContactsSync()   // creates its own CNContactStore
                    cont.resume(returning: results)
                } catch {
                    cont.resume(throwing: error)
                }
            }
        }
    }

    // Runs on a background queue. Creates its own CNContactStore, so nothing Sendable is captured.
    private static func loadContactsSync() throws -> [ContactRecord] {
        let store = CNContactStore()

        let keys: [CNKeyDescriptor] = [
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactNicknameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,          // full-res
            CNContactThumbnailImageDataKey as CNKeyDescriptor  // fallback
        ]

        var results: [ContactRecord] = []
        let request = CNContactFetchRequest(keysToFetch: keys)

        try store.enumerateContacts(with: request) { c, _ in
            // Phones (digits only + human-readable label)
            let labeledPhones: [LabeledPhone] = c.phoneNumbers.compactMap { labeled in
                let raw = labeled.value.stringValue
                let digits = normalizePhone(raw)
                guard !digits.isEmpty else { return nil }
                let label = CNLabeledValue<NSString>
                    .localizedString(forLabel: labeled.label ?? "")
                    .lowercased()
                return LabeledPhone(number: digits, label: label.isEmpty ? nil : label)
            }
            guard !labeledPhones.isEmpty else { return }

            // Display name
            let nameParts = [c.givenName, c.familyName].filter { !$0.isEmpty }
            let display = nameParts.isEmpty ? (c.nickname.isEmpty ? "Unnamed" : c.nickname)
                                            : nameParts.joined(separator: " ")

            // Prefer full-res image; fallback to thumbnail; convert to PNG for SwiftUI Image
            let imagePNG: Data? = {
                if let data = c.imageData, let ui = UIImage(data: data), let png = ui.pngData() { return png }
                if let data = c.thumbnailImageData, let ui = UIImage(data: data), let png = ui.pngData() { return png }
                return nil
            }()

            let sorted = labeledPhones.sorted(by: phoneWeightSort)

            results.append(ContactRecord(
                id: c.identifier,
                fullName: display,
                phones: sorted,
                imagePNG: imagePNG
            ))
        }

        if results.isEmpty { throw FetchError.noContacts }
        return results
    }

    // MARK: - Helpers (static so nothing captures self)
    private static func phoneWeightSort(_ a: LabeledPhone, _ b: LabeledPhone) -> Bool {
        weight(a.label) < weight(b.label)
    }
    private static func weight(_ label: String?) -> Int {
        let l = (label ?? "").lowercased()
        if l.contains("mobile") { return 0 }
        if l.contains("iphone") { return 1 }
        if l.contains("main")   { return 2 }
        if l.contains("work")   { return 3 }
        if l.contains("home")   { return 4 }
        return 5
    }
    /// Keep only digits.
    private static func normalizePhone(_ s: String) -> String {
        var out = ""
        for ch in s where ch.isNumber { out.append(ch) }
        return out
    }
}
