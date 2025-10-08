import SwiftUI

struct SpinWheelAnimation: View {
    let isSpinning: Bool
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0

    var body: some View {
        ZStack {
            // Outer glow ring that pulses during spin
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            ClaudeColors.claudeOrange.opacity(pulseOpacity),
                            ClaudeColors.claudeOrangeDark.opacity(pulseOpacity * 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 8
                )
                .frame(width: 280, height: 280)
                .blur(radius: 10)

            // Main wheel circle
            ZStack {
                // Background gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                ClaudeColors.warmWhite,
                                ClaudeColors.softBeige
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Spinning segments (decorative)
                ForEach(0..<8) { index in
                    Capsule()
                        .fill(ClaudeColors.claudeOrange.opacity(0.1))
                        .frame(width: 4, height: 80)
                        .offset(y: -40)
                        .rotationEffect(.degrees(Double(index) * 45))
                }

                // Center icon
                Image(systemName: "sparkles")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                ClaudeColors.claudeOrange,
                                ClaudeColors.claudeOrangeDark
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(scale)
            }
            .frame(width: 240, height: 240)
            .overlay(
                Circle()
                    .stroke(ClaudeColors.border, lineWidth: 2)
            )
            .shadow(color: ClaudeColors.shadow, radius: 20, x: 0, y: 10)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
        }
        .onChange(of: isSpinning) { _, spinning in
            if spinning {
                startSpinning()
            } else {
                stopSpinning()
            }
        }
    }

    private func startSpinning() {
        // Fast continuous rotation
        withAnimation(.linear(duration: 0.8).repeatCount(3, autoreverses: false)) {
            rotation += 1080 // 3 full rotations
        }

        // Pulse effect
        withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
            pulseOpacity = 0.6
        }

        // Scale bounce
        withAnimation(.easeInOut(duration: 0.15)) {
            scale = 0.95
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                scale = 1.05
            }
        }

        // Return to normal scale
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale = 1.0
            }
        }
    }

    private func stopSpinning() {
        // Smooth deceleration
        withAnimation(.easeOut(duration: 0.6)) {
            rotation = (rotation / 360).rounded() * 360 // Snap to nearest full rotation
        }

        // Fade out pulse
        withAnimation(.easeOut(duration: 0.3)) {
            pulseOpacity = 0
        }

        // Reset scale
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            scale = 1.0
        }
    }
}

struct ContactCardReveal: View {
    let contact: ContactRecord
    let isRevealing: Bool
    @State private var offset: CGFloat = 500
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8

    var body: some View {
        Group {
            // This will be the actual contact card content
            EmptyView()
        }
        .offset(y: offset)
        .opacity(opacity)
        .scaleEffect(scale)
        .onChange(of: isRevealing) { _, revealing in
            if revealing {
                revealCard()
            }
        }
    }

    private func revealCard() {
        // Slide up and fade in
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            offset = 0
            opacity = 1
            scale = 1.0
        }
    }
}

// Confetti particle effect for celebration
struct ConfettiPiece: View {
    let color: Color
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 8, height: 8)
            .offset(offset)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
    }

    func animate() {
        let randomX = Double.random(in: -150...150)
        let randomY = Double.random(in: -200...200)
        let randomRotation = Double.random(in: 0...720)

        withAnimation(.easeOut(duration: 1.5)) {
            offset = CGSize(width: randomX, height: randomY)
            opacity = 0
            rotation = randomRotation
        }
    }
}

struct ConfettiView: View {
    let isActive: Bool
    @State private var pieces: [Int] = []

    var body: some View {
        ZStack {
            ForEach(pieces, id: \.self) { index in
                ConfettiPiece(color: confettiColor(for: index))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                            // Trigger animation
                        }
                    }
            }
        }
        .onChange(of: isActive) { _, active in
            if active {
                pieces = Array(0..<30)
            } else {
                pieces = []
            }
        }
    }

    private func confettiColor(for index: Int) -> Color {
        let colors = [
            ClaudeColors.claudeOrange,
            ClaudeColors.softGreen,
            ClaudeColors.calmBlue,
            ClaudeColors.warmRed
        ]
        return colors[index % colors.count]
    }
}
