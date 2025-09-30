import SwiftUI

struct ManageExclusionsView: View {
    // We just need a reference to the shared view model; no property wrapper needed.
    var vm: RandomContactViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                if vm.excludedContacts().isEmpty {
                    Section {
                        Text("No excluded contacts. Add exclusions from the main screen.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Section("Excluded Contacts") {
                        // Be explicit about the id so SwiftUI doesn't try to infer Bindings
                        ForEach(vm.excludedContacts(), id: \.id) { c in
                            HStack(spacing: 12) {
                                ContactAvatarView(fullName: c.fullName, imagePNG: c.imagePNG, size: 34)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(c.fullName).font(.body)
                                    if let p = c.phones.first {
                                        Text(format(phone: p.number))
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                }

                                Spacer()

                                Button("Restore") {
                                    vm.restore(id: c.id)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                }

                Section {
                    Button {
                        vm.restoreAll()
                    } label: {
                        Label("Restore All", systemImage: "arrow.uturn.left.circle")
                    }
                    .disabled(vm.excludedContacts().isEmpty)
                }
            }
            .navigationTitle("Manage Exclusions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func format(phone: String) -> String {
        let d = phone
        if d.count == 10 {
            let a = d.prefix(3), b = d.dropFirst(3).prefix(3), c = d.suffix(4)
            return "(\(a)) \(b)-\(c)"
        }
        return d
    }
}
