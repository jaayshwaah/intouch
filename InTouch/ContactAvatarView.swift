import SwiftUI

struct ContactAvatarView: View {
    let fullName: String
    let imagePNG: Data?
    let size: CGFloat

    var body: some View {
        ZStack {
            // Enhanced gradient background
            Circle()
                .fill(LinearGradient(colors: [
                    Color(.systemBlue).opacity(0.6),
                    Color(.systemTeal).opacity(0.5),
                    Color(.systemPurple).opacity(0.4)
                ], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    Circle()
                        .fill(LinearGradient(colors: [
                            Color.white.opacity(0.2),
                            Color.clear
                        ], startPoint: .topLeading, endPoint: .bottomTrailing))
                )

            if let data = imagePNG, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(LinearGradient(colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                    )
            } else {
                Text(initials(from: fullName))
                    .font(.system(size: size * 0.38, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
            }
        }
        .frame(width: size, height: size)
        .overlay(
            Circle()
                .stroke(LinearGradient(colors: [
                    Color.white.opacity(0.4),
                    Color.white.opacity(0.2)
                ], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.25), radius: 20, y: 10)
        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
    }

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ").map(String.init)
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.dropFirst().first?.prefix(1) ?? ""
        return (first + last).uppercased()
    }
}
