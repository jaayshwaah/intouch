import SwiftUI

// MARK: - Logo Loading Animation
struct LogoLoadingAnimation: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            // Rotation: 360° every 2 seconds
            let rotation = (time * 180).truncatingRemainder(dividingBy: 360)

            // Pulse: 1.0 → 1.1 → 1.0 every 1.5 seconds
            let pulseProgress = (time / 1.5).truncatingRemainder(dividingBy: 1.0)
            let scale = pulseProgress < 0.5
                ? 1.0 + (0.1 * pulseProgress * 2) // 1.0 → 1.1
                : 1.1 - (0.1 * (pulseProgress - 0.5) * 2) // 1.1 → 1.0

            Image("LoadingLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
        }
    }
}

// MARK: - Wrapper with Claude aesthetic
struct LogoLoadingView: View {
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                // Soft background glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                ClaudeColors.claudeOrange.opacity(0.15),
                                ClaudeColors.claudeOrange.opacity(0.08),
                                ClaudeColors.claudeOrange.opacity(0.03),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)

                // The logo animation
                LogoLoadingAnimation()
            }
            .frame(maxWidth: .infinity)

            Text("Picking someone special...")
                .font(ClaudeTypography.bodyFont)
                .foregroundStyle(ClaudeColors.mediumGray)
        }
        .claudeCard(padding: 40)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        ClaudeBackground()
        LogoLoadingView()
    }
}
