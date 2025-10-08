import SwiftUI

struct ManageExclusionsView: View {
    @Bindable var vm: RandomContactViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                infoCard
                    .claudeColumnLayout()

                if vm.excludedIDs.isEmpty {
                    emptyState
                        .claudeColumnLayout()
                } else {
                    excludedList
                        .claudeColumnLayout()

                    restoreAllButton
                        .claudeColumnLayout()
                }

                Spacer(minLength: 40)
            }
            .padding(.vertical, 20)
        }
        .background(ClaudeBackground().ignoresSafeArea())
        .navigationTitle("Manage Exclusions")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .font(ClaudeTypography.calloutFont)
                .foregroundStyle(ClaudeColors.claudeOrange)
            }
        }
    }

    // MARK: - Info Card

    private var infoCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(ClaudeColors.calmBlue)

            Text("Excluded contacts won't appear in your spins. You can restore them at any time.")
                .font(ClaudeTypography.subheadlineFont)
                .foregroundStyle(ClaudeColors.charcoal)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ClaudeColors.calmBlue.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(ClaudeColors.calmBlue.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(ClaudeColors.softGreen)

            Text("No Exclusions")
                .font(ClaudeTypography.title2Font)
                .foregroundStyle(ClaudeColors.charcoal)

            Text("All your contacts are eligible to appear in spins")
                .font(ClaudeTypography.bodyFont)
                .foregroundStyle(ClaudeColors.mediumGray)
                .multilineTextAlignment(.center)
        }
        .claudeCard(padding: 40)
    }

    // MARK: - Excluded List

    private var excludedList: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "person.crop.circle.badge.xmark")
                    .font(.system(size: 20))
                    .foregroundStyle(ClaudeColors.warmRed)
                Text("Excluded Contacts (\(vm.excludedIDs.count))")
                    .font(ClaudeTypography.title3Font)
                    .foregroundStyle(ClaudeColors.charcoal)
            }

            VStack(spacing: 12) {
                ForEach(vm.excludedContacts()) { contact in
                    contactRow(contact)
                }
            }
        }
        .claudeCard(padding: 24)
    }

    private func contactRow(_ contact: ContactRecord) -> some View {
        HStack(spacing: 14) {
            ContactAvatarView(
                fullName: contact.fullName,
                imagePNG: contact.imagePNG,
                size: 48
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(contact.fullName)
                    .font(ClaudeTypography.calloutFont)
                    .foregroundStyle(ClaudeColors.charcoal)

                if let phone = contact.phones.first {
                    Text(formatPhone(phone.number))
                        .font(ClaudeTypography.footnoteFont)
                        .foregroundStyle(ClaudeColors.mediumGray)
                }
            }

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    vm.restore(id: contact.id)
                }
            } label: {
                Text("Restore")
                    .font(ClaudeTypography.calloutFont)
                    .fontWeight(.medium)
                    .foregroundStyle(ClaudeColors.claudeOrange)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(ClaudeColors.claudeOrange.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .stroke(ClaudeColors.claudeOrange.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(14)
        .background(ClaudeColors.warmWhite)
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ClaudeColors.border, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    // MARK: - Restore All Button

    private var restoreAllButton: some View {
        Button {
            withAnimation(.easeInOut) {
                vm.restoreAll()
            }
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Restore All Contacts")
            }
            .frame(maxWidth: .infinity)
        }
        .claudeSecondaryButton()
    }

    // MARK: - Helper

    private func formatPhone(_ phone: String) -> String {
        let d = phone
        if d.count == 10 {
            let a = d.prefix(3), b = d.dropFirst(3).prefix(3), c = d.suffix(4)
            return "(\(a)) \(b)-\(c)"
        }
        return d
    }
}
