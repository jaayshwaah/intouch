import Foundation

struct LabeledPhone: Identifiable, Hashable {
    var id: String { number + (label ?? "") }
    let number: String    // digits-only
    let label: String?    // "mobile", "work", etc.
}

struct ContactRecord: Identifiable, Hashable {
    let id: String                // CNContact.identifier
    let fullName: String
    let phones: [LabeledPhone]    // sorted with "mobile" preferred
    let imagePNG: Data?           // prefer full-res, fallback to thumbnail

    var hasImage: Bool { imagePNG != nil }
}
