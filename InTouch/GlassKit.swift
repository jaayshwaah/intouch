import SwiftUI

// MARK: - Liquid glass background
struct LiquidGlassBackground: View {
    @State private var animateGradient = false
    @State private var backgroundOffset: CGFloat = 0
    @State private var blobOffset1: CGFloat = 0
    @State private var blobOffset2: CGFloat = 0
    @State private var blobOffset3: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Enhanced gradient background with subtle movement
            RadialGradient(
                colors: [
                    Color(.systemTeal).opacity(0.4),
                    Color(.systemBlue).opacity(0.3),
                    Color(.systemIndigo).opacity(0.25),
                    Color(.systemPurple).opacity(0.2),
                    Color(.black).opacity(0.8)
                ],
                center: .center,
                startRadius: 60,
                endRadius: 900
            )
            .ignoresSafeArea()
            .offset(x: backgroundOffset * CGFloat(0.3), y: backgroundOffset * CGFloat(0.2))
            .animation(.easeInOut(duration: 20).repeatForever(autoreverses: true), value: backgroundOffset)

            // Additional gradient overlay for depth with movement
            LinearGradient(
                colors: [
                    Color(.systemBlue).opacity(0.1),
                    Color.clear,
                    Color(.systemPurple).opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .offset(x: -backgroundOffset * CGFloat(0.2), y: backgroundOffset * CGFloat(0.1))
            .animation(.easeInOut(duration: 25).repeatForever(autoreverses: true), value: backgroundOffset)

            // Enhanced ambient blobs with individual slow movements
            Circle().fill(.ultraThinMaterial)
                .frame(width: 400, height: 400)
                .blur(radius: 40)
                .offset(x: -160.0 + blobOffset1 * CGFloat(0.5), y: -300.0 + blobOffset1 * CGFloat(0.3))
                .offset(x: animateGradient ? 20 : -20, y: animateGradient ? 10 : -10)
                .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animateGradient)
                .animation(.easeInOut(duration: 30).repeatForever(autoreverses: true), value: blobOffset1)

            Circle().fill(.thinMaterial)
                .frame(width: 200, height: 200)
                .blur(radius: 25)
                .offset(x: 200.0 + blobOffset2 * CGFloat(0.3), y: -200.0 + blobOffset2 * CGFloat(0.4))
                .offset(x: animateGradient ? -15 : 15, y: animateGradient ? 20 : -20)
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animateGradient)
                .animation(.easeInOut(duration: 35).repeatForever(autoreverses: true), value: blobOffset2)

            RoundedRectangle(cornerRadius: 250)
                .fill(
                    LinearGradient(colors: [
                        Color.white.opacity(0.2), 
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .topLeading, 
                    endPoint: .bottomTrailing)
                )
                .frame(width: 580, height: 360)
                .rotationEffect(.degrees(Double(-12.0 + blobOffset3 * CGFloat(0.1))))
                .blur(radius: 30)
                .offset(x: 180.0 + blobOffset3 * CGFloat(0.4), y: 280.0 + blobOffset3 * CGFloat(0.2))
                .offset(x: animateGradient ? 30 : -30, y: animateGradient ? -15 : 15)
                .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateGradient)
                .animation(.easeInOut(duration: 40).repeatForever(autoreverses: true), value: blobOffset3)
        }
        .onAppear {
            animateGradient = true
            
            // Start slow background movements with slight delays for natural feel
            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true).delay(0)) {
                backgroundOffset = 1
            }
            
            withAnimation(.easeInOut(duration: 30).repeatForever(autoreverses: true).delay(2)) {
                blobOffset1 = 1
            }
            
            withAnimation(.easeInOut(duration: 35).repeatForever(autoreverses: true).delay(4)) {
                blobOffset2 = 1
            }
            
            withAnimation(.easeInOut(duration: 40).repeatForever(autoreverses: true).delay(6)) {
                blobOffset3 = 1
            }
        }
    }
}

// MARK: - Adaptive center column (prevents horizontal overflow on all iPhones)
private struct CenterColumnAdaptive: ViewModifier {
    @Environment(\.horizontalSizeClass) private var hSize

    // Tuned for iPhone widths: 360 is safe for the narrowest devices; 520 for Pro Max/regular.
    var compactMax: CGFloat = 360
    var regularMax: CGFloat = 520
    var horizontalPadding: CGFloat = 16

    func body(content: Content) -> some View {
        let cap = (hSize == .compact) ? compactMax : regularMax
        return content
            .frame(maxWidth: cap, alignment: .center)   // clamp the actual content
            .padding(.horizontal, horizontalPadding)    // breathing room from edges
            .frame(maxWidth: .infinity, alignment: .center) // center the column
    }
}
extension View {
    /// Constrain content to a safe, adaptive column width (prevents overflow on every iPhone).
    func centerColumnAdaptive(compactMax: CGFloat = 360, regularMax: CGFloat = 520) -> some View {
        modifier(CenterColumnAdaptive(compactMax: compactMax, regularMax: regularMax))
    }
}

// MARK: - Glass card & button styles
struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }

    var body: some View {
        content
            .padding(24)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(
                            LinearGradient(colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(
                        LinearGradient(colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.15)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing), 
                        lineWidth: 1.5
                    )
                    .blendMode(.overlay)
            )
            .shadow(color: .black.opacity(0.3), radius: 40, y: 20)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
}

struct GlassButtonStyle: ButtonStyle {
    let prominent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if prominent {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(
                                        LinearGradient(colors: [
                                            Color.white.opacity(0.2),
                                            Color.white.opacity(0.1)
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(
                                        LinearGradient(colors: [
                                            Color.white.opacity(0.4),
                                            Color.white.opacity(0.2)
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing), 
                                        lineWidth: 1.5
                                    )
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(
                                        LinearGradient(colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.15)
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing), 
                                        lineWidth: 1
                                    )
                            )
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

extension Button {
    func glassProminent() -> some View { self.buttonStyle(GlassButtonStyle(prominent: true)) }
    func glass() -> some View { self.buttonStyle(GlassButtonStyle(prominent: false)) }
}

struct GlassChip: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 6).padding(.horizontal, 10)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(.white.opacity(0.4), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
    }
}
