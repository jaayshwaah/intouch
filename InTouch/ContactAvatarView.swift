import SwiftUI

struct ContactAvatarView: View {
    let fullName: String
    let imagePNG: Data?
    let size: CGFloat

    var body: some View {
        ZStack {
            // Soft gradient background for initials
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            ClaudeColors.claudeOrange.opacity(0.3),
                            ClaudeColors.claudeOrangeDark.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            if let data = imagePNG, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(ClaudeColors.border, lineWidth: 2)
                    )
            } else {
                Text(initials(from: fullName))
                    .font(.system(size: size * 0.38, weight: .semibold))
                    .foregroundStyle(ClaudeColors.claudeOrange)
            }
        }
        .frame(width: size, height: size)
    }

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ").map(String.init)
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.dropFirst().first?.prefix(1) ?? ""
        return (first + last).uppercased()
    }
}
