import SwiftUI

// MARK: - Circular Text Spinner Animation
struct CircularTextSpinner: View {
    let text: String
    let radius: CGFloat
    let fontSize: CGFloat
    let letterSpacing: Double

    init(
        text: String = "STAY IN TOUCH • STAY IN TOUCH • ",
        radius: CGFloat = 80,
        fontSize: CGFloat = 18,
        letterSpacing: Double = 10.6
    ) {
        self.text = text
        self.radius = radius
        self.fontSize = fontSize
        self.letterSpacing = letterSpacing
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            ZStack {
                ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                    Text(String(character))
                        .font(.system(size: fontSize, weight: .semibold, design: .rounded))
                        .foregroundStyle(ClaudeColors.claudeOrange)
                        .kerning(1)
                        .rotationEffect(.degrees(-Double(index) * letterSpacing - time * 90)) // Counter-rotate to keep upright
                        .offset(y: -radius)
                        .rotationEffect(.degrees(Double(index) * letterSpacing + time * 90))
                }
            }
            .frame(width: radius * 2, height: radius * 2)
        }
    }

    private func calculateOpacity(for index: Int, time: TimeInterval) -> Double {
        let totalLetters = Double(text.count)

        // Wave cycle duration: total fade out + total fade in = ~8 seconds
        let fadeOutDuration = totalLetters * 0.3 * 0.72 // accounting for overlap (-0.28)
        let fadeInDuration = totalLetters * 0.3 * 0.72
        let pauseDuration = 0.8
        let cycleDuration = fadeOutDuration + pauseDuration + fadeInDuration + pauseDuration

        let cycleProgress = time.truncatingRemainder(dividingBy: cycleDuration)

        // Phase 1: Fade out wave
        if cycleProgress < fadeOutDuration {
            let letterStartTime = Double(index) * 0.3 * 0.72
            let letterEndTime = letterStartTime + 0.3

            if cycleProgress >= letterStartTime && cycleProgress < letterEndTime {
                let letterProgress = (cycleProgress - letterStartTime) / 0.3
                return 1.0 - letterProgress // Fade out
            } else if cycleProgress >= letterEndTime {
                return 0.0 // Already faded out
            } else {
                return 1.0 // Not started fading yet
            }
        }
        // Phase 2: Pause (all invisible)
        else if cycleProgress < fadeOutDuration + pauseDuration {
            return 0.0
        }
        // Phase 3: Fade in wave
        else if cycleProgress < fadeOutDuration + pauseDuration + fadeInDuration {
            let fadeInStart = fadeOutDuration + pauseDuration
            let fadeInProgress = cycleProgress - fadeInStart
            let letterStartTime = Double(index) * 0.3 * 0.72
            let letterEndTime = letterStartTime + 0.3

            if fadeInProgress >= letterStartTime && fadeInProgress < letterEndTime {
                let letterProgress = (fadeInProgress - letterStartTime) / 0.3
                return letterProgress // Fade in
            } else if fadeInProgress >= letterEndTime {
                return 1.0 // Already faded in
            } else {
                return 0.0 // Not started fading yet
            }
        }
        // Phase 4: Pause (all visible)
        else {
            return 1.0
        }
    }
}

// MARK: - Wrapper with Claude aesthetic
struct CircularTextSpinnerView: View {
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

                // The circular text spinner
                CircularTextSpinner()
            }
            .frame(maxWidth: .infinity)
        }
        .claudeCard(padding: 40)
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        ClaudeBackground()
        CircularTextSpinnerView()
    }
}
