import SwiftUI

// MARK: - Claude-Inspired Design System

/// Color palette inspired by Anthropic's Claude aesthetic
/// Warm, sophisticated, professional with signature orange accent
struct ClaudeColors {
    // Primary colors
    static let claudeOrange = Color(red: 0.93, green: 0.49, blue: 0.25) // #ED7D40
    static let claudeOrangeDark = Color(red: 0.85, green: 0.42, blue: 0.18)

    // Background colors
    static let cream = Color(red: 0.98, green: 0.97, blue: 0.95) // #FAF8F2
    static let warmWhite = Color(red: 0.99, green: 0.98, blue: 0.97)
    static let softBeige = Color(red: 0.96, green: 0.94, blue: 0.91)

    // Text colors
    static let charcoal = Color(red: 0.15, green: 0.14, blue: 0.13) // #262321
    static let darkGray = Color(red: 0.35, green: 0.33, blue: 0.31)
    static let mediumGray = Color(red: 0.55, green: 0.53, blue: 0.51)
    static let lightGray = Color(red: 0.75, green: 0.73, blue: 0.71)

    // Accent colors
    static let warmRed = Color(red: 0.89, green: 0.33, blue: 0.28)
    static let softGreen = Color(red: 0.45, green: 0.72, blue: 0.51)
    static let calmBlue = Color(red: 0.38, green: 0.55, blue: 0.75)

    // Utility
    static let border = Color(red: 0.88, green: 0.86, blue: 0.83)
    static let shadow = Color.black.opacity(0.08)
}

/// Typography system matching Claude's clean, readable aesthetic
struct ClaudeTypography {
    // Font family - SF Pro with specific weights
    static let displayFont = Font.system(.largeTitle, design: .default, weight: .bold)
    static let titleFont = Font.system(.title, design: .default, weight: .semibold)
    static let title2Font = Font.system(.title2, design: .default, weight: .semibold)
    static let title3Font = Font.system(.title3, design: .default, weight: .medium)
    static let headlineFont = Font.system(.headline, design: .default, weight: .semibold)
    static let bodyFont = Font.system(.body, design: .default, weight: .regular)
    static let calloutFont = Font.system(.callout, design: .default, weight: .medium)
    static let subheadlineFont = Font.system(.subheadline, design: .default, weight: .regular)
    static let footnoteFont = Font.system(.footnote, design: .default, weight: .regular)
    static let captionFont = Font.system(.caption, design: .default, weight: .regular)
}

// MARK: - Background Components

struct ClaudeBackground: View {
    var body: some View {
        ZStack {
            // Base cream color
            ClaudeColors.cream
                .ignoresSafeArea()

            // Subtle grain texture overlay
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.clear,
                            ClaudeColors.softBeige.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea()
        }
    }
}

// MARK: - Card Components

struct ClaudeCard<Content: View>: View {
    let content: Content
    let padding: CGFloat

    init(padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(ClaudeColors.warmWhite)
                    .shadow(color: ClaudeColors.shadow, radius: 8, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(ClaudeColors.border, lineWidth: 1)
                    )
            )
    }
}

struct ClaudeCardHighlight<Content: View>: View {
    let content: Content
    let padding: CGFloat

    init(padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                ClaudeColors.claudeOrange.opacity(0.1),
                                ClaudeColors.claudeOrange.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: ClaudeColors.claudeOrange.opacity(0.1), radius: 12, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(ClaudeColors.claudeOrange.opacity(0.3), lineWidth: 1.5)
                    )
            )
    }
}

// MARK: - Button Styles

struct ClaudePrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(ClaudeTypography.calloutFont)
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(ClaudeColors.claudeOrange)
                    .shadow(color: ClaudeColors.claudeOrange.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct ClaudeSecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(ClaudeTypography.calloutFont)
            .foregroundStyle(ClaudeColors.charcoal)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(ClaudeColors.warmWhite)
                    .shadow(color: ClaudeColors.shadow, radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ClaudeColors.border, lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct ClaudeGhostButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(ClaudeTypography.calloutFont)
            .foregroundStyle(ClaudeColors.claudeOrange)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(configuration.isPressed ? ClaudeColors.claudeOrange.opacity(0.1) : Color.clear)
            )
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Badge Component

struct ClaudeBadge: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color = ClaudeColors.claudeOrange) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(ClaudeTypography.captionFont)
            .fontWeight(.medium)
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(color.opacity(0.1))
                    .overlay(
                        Capsule()
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

// MARK: - Divider

struct ClaudeDivider: View {
    var body: some View {
        Rectangle()
            .fill(ClaudeColors.border)
            .frame(height: 1)
    }
}

// MARK: - Icon Button

struct ClaudeIconButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(ClaudeColors.charcoal)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(ClaudeColors.warmWhite)
                        .shadow(color: ClaudeColors.shadow, radius: 4, x: 0, y: 2)
                        .overlay(
                            Circle()
                                .stroke(ClaudeColors.border, lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - View Modifiers

extension View {
    func claudeCard(padding: CGFloat = 20) -> some View {
        ClaudeCard(padding: padding) {
            self
        }
    }

    func claudeCardHighlight(padding: CGFloat = 20) -> some View {
        ClaudeCardHighlight(padding: padding) {
            self
        }
    }

    func claudePrimaryButton() -> some View {
        self.buttonStyle(ClaudePrimaryButton())
    }

    func claudeSecondaryButton() -> some View {
        self.buttonStyle(ClaudeSecondaryButton())
    }

    func claudeGhostButton() -> some View {
        self.buttonStyle(ClaudeGhostButton())
    }
}

// MARK: - Column Layout Helper

extension View {
    func claudeColumnLayout(maxWidth: CGFloat = 600) -> some View {
        self
            .frame(maxWidth: maxWidth)
            .padding(.horizontal, 20)
    }
}
