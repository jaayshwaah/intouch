import SwiftUI
import MessageUI

struct RandomContactView: View {
    @State private var vm = RandomContactViewModel()
    @State private var subscriptionManager = SubscriptionManager.shared
    @State private var showManage = false
    @State private var showResetSeenAlert = false
    @State private var showSMS = false
    @State private var showPaywall = false
    @State private var cardFlip = false
    @State private var isSpinning = false
    @State private var spinAngle: Double = 0
    @Environment(\.horizontalSizeClass) private var hSize

    private var isCompact: Bool { hSize == .compact }
    private var avatarSize: CGFloat { isCompact ? 64 : 80 }

    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()

                ScrollView {
                    VStack(spacing: 22) {
                        header
                            .padding(.top, 12)
                            .centerColumnAdaptive()

                        if vm.isLoading {
                            ProgressView().controlSize(.large)
                                .tint(.white)
                                .padding(.top, 40)
                                .centerColumnAdaptive()
                        } else if let msg = vm.statusMessage {
                            GlassCard {
                                VStack(spacing: 12) {
                                    Text(msg)
                                        .font(.title3.weight(.semibold))
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(.white.opacity(0.9))
                                    Button {
                                        vm.openAppSettings()
                                    } label: {
                                        Label("Fix in Settings", systemImage: "gear")
                                    }
                                    .glass()
                                }
                            }
                            .centerColumnAdaptive()
                        } else if let c = vm.current {
                            contactCard(c)
                                .centerColumnAdaptive()
                                .rotation3DEffect(.degrees(cardFlip ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                                .rotationEffect(.degrees(isSpinning ? spinAngle : 0))
                                .scaleEffect(isSpinning ? 0.95 : 1.0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: cardFlip)
                                .animation(.easeInOut(duration: 0.3), value: isSpinning)

                            controls(for: c)
                                .centerColumnAdaptive()
                        } else {
                            GlassCard {
                                VStack(spacing: 10) {
                                    Text("Ready to reconnect?")
                                        .font(.title2.weight(.bold))
                                        .foregroundStyle(.white.opacity(0.95))
                                    Text("Tap Spin to get your first contact.")
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                            }
                            .centerColumnAdaptive()
                        }

                        Spacer(minLength: 24)
                    }
                    .safeAreaPadding(.vertical, 10)
                    .dynamicTypeSize(.xSmall ... .accessibility2)
                }
            }
            .toolbar { topToolbar }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task { 
            await vm.bootstrap()
            await subscriptionManager.updateSubscriptionStatus()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    // MARK: - UI chunks

    private var header: some View {
        VStack(spacing: 8) {
            Text("InTouch")
                .font(.system(size: 34, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
            
            if !subscriptionManager.isSubscribed {
                let remaining = subscriptionManager.remainingFreeSpins()
                if remaining > 0 {
                    Text("\(remaining) free spins remaining today")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.95))
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                } else {
                    Button {
                        showPaywall = true
                    } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                            Text("Upgrade for unlimited spins")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(colors: [
                                Color.blue,
                                Color.purple
                            ], startPoint: .leading, endPoint: .trailing),
                            in: Capsule()
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                    }
                }
            }
        }
    }


    private func contactCard(_ c: ContactRecord) -> some View {
        let primary = vm.primaryPhone(for: c)

        return GlassCard {
            VStack(alignment: .leading, spacing: 18) {
                // Header with options button
                HStack {
                    Spacer()
                    Button {
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        withAnimation(.easeInOut) { vm.excludeCurrent() }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.7))
                            .background(Circle().fill(.ultraThinMaterial).frame(width: 32, height: 32))
                    }
                }

                // Use horizontal layout when it truly fits; otherwise vertical.
                ViewThatFits(in: .horizontal) {

                    // HORIZONTAL
                    HStack(alignment: .center, spacing: 20) {
                        ContactAvatarView(fullName: c.fullName, imagePNG: c.imagePNG, size: avatarSize + 8)
                        nameAndPrimary(c: c, primary: primary)
                            .layoutPriority(1) // prefer text to compress avatar
                        Spacer(minLength: 0)
                    }

                    // VERTICAL
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Spacer()
                            ContactAvatarView(fullName: c.fullName, imagePNG: c.imagePNG, size: avatarSize + 16)
                            Spacer()
                        }
                        nameAndPrimary(c: c, primary: primary)
                    }
                }

                // Extra numbers listed vertically (full numbers)
                let extra = Array(c.phones.dropFirst())
                if !extra.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(extra) { e in
                            HStack(spacing: 8) {
                                if let label = e.label { GlassChip(text: label.capitalized) }
                                Text(format(phone: e.number))
                                    .foregroundStyle(.white.opacity(0.9))
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
        }
    }

    private func nameAndPrimary(c: ContactRecord, primary: LabeledPhone?) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(c.fullName)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white.opacity(0.98))
                .lineLimit(2)                 // wrap instead of overflow
                .minimumScaleFactor(0.85)

            if let p = primary {
                HStack(spacing: 8) {
                    Text(format(phone: p.number))
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                    if let label = p.label {
                        GlassChip(text: label.capitalized)
                    }
                }
            }
        }
    }

    private func controls(for c: ContactRecord) -> some View {
        let primary = vm.primaryPhone(for: c)?.number

        return VStack(spacing: 16) {
            HStack(spacing: 16) {
                Button {
                    guard let n = primary else { return }
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.9)
                    vm.call(number: n)
                } label: {
                    Label("Call", systemImage: "phone.fill")
                }
                .glassProminent()

                Button {
                    guard let n = primary else { return }
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.9)
                    if MFMessageComposeViewController.canSendText() {
                        showSMS = true
                    } else {
                        vm.textFallbackURL(number: n)
                    }
                } label: {
                    Label("Text", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .glass()
                .sheet(isPresented: $showSMS) {
                    if let n = vm.primaryPhone(for: c)?.number {
                        MessageComposer(recipients: [n]).ignoresSafeArea()
                    }
                }
            }

            Button { spinWithFX() } label: {
                Label("Spin Again", systemImage: "shuffle")
            }
            .glass()
        }
    }

    private func spinWithFX() {
        // Check if user can spin
        guard subscriptionManager.canSpin() else {
            showPaywall = true
            return
        }
        
        UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 1.0)
        
        // Record the spin for usage tracking
        subscriptionManager.recordSpin()
        
        // Start spinning animation
        withAnimation(.easeInOut(duration: 0.1)) {
            isSpinning = true
        }
        
        // Rotate multiple times during spin
        withAnimation(.linear(duration: 0.8)) {
            spinAngle += 720 // Two full rotations
        }
        
        cardFlip.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                vm.spin()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                cardFlip.toggle()
                // Stop spinning animation
                withAnimation(.easeOut(duration: 0.2)) {
                    isSpinning = false
                    spinAngle = 0
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

    private var topToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Menu {
                if subscriptionManager.isSubscribed {
                    Button {
                        // Open subscription management
                        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Manage Subscription", systemImage: "crown.fill")
                    }
                } else {
                    Button { showPaywall = true } label: {
                        Label("Upgrade to Premium", systemImage: "crown.fill")
                    }
                }
                
                Toggle(isOn: Binding(get: { vm.noRepeatsEver }, set: { vm.setNoRepeatsEver($0) })) {
                    Label("No repeats (ever)", systemImage: "infinity.circle")
                }
                Button { showManage = true } label: {
                    Label("Manage Exclusions", systemImage: "person.crop.circle.badge.xmark")
                }
                Divider()
                Button(role: .destructive) { showResetSeenAlert = true } label: {
                    Label("Clear 'Seen' History", systemImage: "clock.arrow.circlepath")
                }
            } label: {
                Image(systemName: "gearshape").foregroundStyle(.white)
            }
        }
    }
}
