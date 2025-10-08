import SwiftUI

// MARK: - Main Container
struct MetronomeLoadingAnimation: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            return ZStack {
                ForEach(0..<36, id: \.self) { index in
                    BatonContainer(index: index, time: time)
                }
            }
            .frame(width: 140, height: 140)
        }
    }
}

// MARK: - Baton Container (outer rotation)
struct BatonContainer: View {
    let index: Int
    let time: TimeInterval

    var body: some View {
        // This represents the baton-{N} div
        // The baton extends outward from center, rotating around its inner end (trailing anchor)
        MetronomeSwing(index: index, time: time)
            .rotationEffect(.degrees(Double(index) * 10), anchor: .trailing)
            .offset(x: -25) // Shift left by half the baton width to center the circle
    }
}

// MARK: - Metronome Swing (middle layer)
struct MetronomeSwing: View {
    let index: Int
    let time: TimeInterval

    private let batonColor = ClaudeColors.claudeOrange
    private let dotColor = ClaudeColors.claudeOrangeDark

    var body: some View {
        let delay = Double(index) * 0.035 // Stagger effect (-0.14s in CSS)
        let adjustedTime = time - delay
        let cycle = adjustedTime.truncatingRemainder(dividingBy: 1.25)
        let progress = cycle / 1.25

        // Metronome rotation: -25° → 25° → -25°
        let metronomeRotation: Double
        if progress < 0.5 {
            metronomeRotation = -25 + (50 * progress * 2)
        } else {
            metronomeRotation = 25 - (50 * (progress - 0.5) * 2)
        }

        // This represents the .metronome div
        // transform-origin: 0 (left side), rotates back and forth
        return Baton(index: index, time: time)
            .rotationEffect(.degrees(metronomeRotation), anchor: .leading)
    }
}

// MARK: - Baton (innermost - the actual line)
struct Baton: View {
    let index: Int
    let time: TimeInterval

    private let batonColor = ClaudeColors.claudeOrange
    private let dotColor = ClaudeColors.claudeOrangeDark

    var body: some View {
        let delay = Double(index) * 0.035
        let adjustedTime = time - delay
        let cycle = adjustedTime.truncatingRemainder(dividingBy: 1.25)
        let progress = cycle / 1.25

        // Scale animation: 1.0 → 0.74 → 1.0 → 1.16 → 1.0
        let batonScale: CGFloat
        if progress < 0.25 {
            batonScale = 1.0 - (0.26 * (progress / 0.25))
        } else if progress < 0.5 {
            batonScale = 0.74 + (0.26 * ((progress - 0.25) / 0.25))
        } else if progress < 0.75 {
            batonScale = 1.0 + (0.16 * ((progress - 0.5) / 0.25))
        } else {
            batonScale = 1.16 - (0.16 * ((progress - 0.75) / 0.25))
        }

        // This represents the .baton div
        // width: 50px, height: 2px, transform-origin: 0, rotate: -10deg
        return ZStack(alignment: .leading) {
            // The baton line
            Rectangle()
                .fill(batonColor)
                .frame(width: 50, height: 2)
                .scaleEffect(x: batonScale, y: 1.0, anchor: .leading)

            // :before pseudo-element (left dot)
            Circle()
                .fill(dotColor)
                .frame(width: 4, height: 4)
                .offset(x: -2, y: -1)

            // :after pseudo-element (right dot)
            Circle()
                .fill(dotColor)
                .frame(width: 4, height: 4)
                .offset(x: 50 - 2, y: -1)
        }
        .rotationEffect(.degrees(-10), anchor: .leading)
    }
}

// MARK: - Wrapper with Claude aesthetic
struct MetronomeLoadingView: View {
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

                // The metronome animation
                MetronomeLoadingAnimation()
            }
            .frame(maxWidth: .infinity)

            Text("Finding your next connection...")
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
        MetronomeLoadingView()
    }
}
