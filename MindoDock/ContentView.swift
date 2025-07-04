import SwiftUI
import AppKit

struct PillWidget<Content: View>: View {
    let icon: String?
    let iconColor: Color?
    let label: String
    let minWidth: CGFloat
    let maxWidth: CGFloat
    let height: CGFloat
    let content: Content?
    let glow: Bool
    let multiline: Bool
    let expanded: Bool
    let leadingImage: Image?
    init(icon: String? = nil, iconColor: Color? = nil, label: String, minWidth: CGFloat, maxWidth: CGFloat, height: CGFloat, glow: Bool = true, multiline: Bool = false, expanded: Bool = false, leadingImage: Image? = nil, @ViewBuilder content: () -> Content? = { nil }) {
        self.icon = icon
        self.iconColor = iconColor
        self.label = label
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.height = height
        self.content = content()
        self.glow = glow
        self.multiline = multiline
        self.expanded = expanded
        self.leadingImage = leadingImage
    }
    var body: some View {
        HStack(spacing: 10) {
            if let leadingImage = leadingImage {
                leadingImage
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: expanded ? 44 : 36, height: expanded ? 44 : 36)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: .white.opacity(0.08), radius: 6, y: 1)
            } else if let icon = icon, let iconColor = iconColor {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(expanded ? 0.32 : 0.22))
                        .frame(width: expanded ? 28 : 20, height: expanded ? 28 : 20)
                    Image(systemName: icon)
                        .font(.system(size: expanded ? 15 : 12, weight: .semibold))
                        .foregroundColor(iconColor)
                }
            }
            if multiline {
                Text(label)
                    .font(.system(size: expanded ? 16 : 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.8)
            } else {
                Text(label)
                    .font(.system(size: expanded ? 16 : 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.92))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            if let content = content {
                content
            }
        }
        .padding(.horizontal, expanded ? 24 : 16)
        .padding(.vertical, expanded ? 14 : 10)
        .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: height, maxHeight: height)
        .background(
            Capsule()
                .fill(Color.white.opacity(expanded ? 0.18 : 0.12))
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.22))
                )
                .overlay(
                    Capsule()
                        .stroke((iconColor ?? .white).opacity(expanded ? 0.32 : 0.18), lineWidth: expanded ? 2 : 1)
                )
                .overlay(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.10), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .blur(radius: 2)
                        .opacity(0.7)
                )
        )
        .shadow(color: glow ? (iconColor ?? .white).opacity(expanded ? 0.22 : 0.13) : .clear, radius: glow ? (expanded ? 16 : 10) : 0, y: 2)
        .scaleEffect(expanded ? 1.10 : 1)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: expanded)
    }
}

struct CloseMinimizeButtons: View {
    var body: some View {
        HStack(spacing: 8) {
            Button(action: { NSApp.terminate(nil) }) {
                Circle().fill(Color.red).frame(width: 10, height: 10)
            }
            .buttonStyle(.plain)
            Button(action: {
                if let window = NSApplication.shared.windows.first {
                    window.miniaturize(nil)
                }
            }) {
                Circle().fill(Color.yellow).frame(width: 10, height: 10)
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 8)
    }
}

struct ExpandableIslandView: View {
    @State private var isExpanded = false
    @State private var dragOffset: CGFloat = 0
    @State private var windowX: CGFloat = 0
    @State private var hoveredWidget: Int? = nil
    let width: CGFloat = 700
    let collapsedHeight: CGFloat = 44
    let expandedHeight: CGFloat = 140
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // True black glassy background with highlight
                ExpandableIslandShape(expansion: isExpanded ? 1 : 0)
                    .fill(Color.black)
                    .overlay(
                        LinearGradient(
                            colors: [Color.white.opacity(0.10), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(ExpandableIslandShape(expansion: isExpanded ? 1 : 0))
                    )
                    .shadow(color: .black.opacity(0.28), radius: 44, y: 14)
                    .frame(width: width, height: expandedHeight)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isExpanded)
                // Focused, elegant border
                ExpandableIslandShape(expansion: isExpanded ? 1 : 0)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.28),
                                Color.purple.opacity(0.22),
                                Color.white.opacity(0.13)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isExpanded ? 2.5 : 1.5
                    )
                    .blur(radius: isExpanded ? 2 : 1)
                    .opacity(0.8)
                    .frame(width: width, height: expandedHeight)
                    .animation(.easeInOut(duration: 0.5), value: isExpanded)
                // Content clipped to island shape
                ZStack {
                    VStack(spacing: 0) {
                        // Tab/handle with logo and window controls, perfectly centered
                        ZStack(alignment: .center) {
                            HStack {
                                CloseMinimizeButtons()
                                Spacer()
                            }
                            .frame(height: collapsedHeight)
                            HStack {
                                Spacer()
                                ZStack {
                                    Capsule()
                                        .fill(Color.black.opacity(0.85))
                                    Capsule()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.blue,
                                                    Color.purple,
                                                    Color.cyan,
                                                    Color.blue
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                            lineWidth: 2.5
                                        )
                                        .blur(radius: 4)
                                        .opacity(0.7)
                                    Capsule()
                                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                                    // Glass highlight
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.13), .clear],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .blur(radius: 2)
                                        .opacity(0.7)
                                    Text("MINDO")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(.white.opacity(0.92))
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 24)
                                }
                                .offset(y: 10)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        isExpanded.toggle()
                                    }
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let newX = windowX + value.translation.width
                                            dragOffset = value.translation.width
                                            AppDelegate.setWindowX(newX)
                                        }
                                        .onEnded { value in
                                            windowX += value.translation.width
                                            dragOffset = 0
                                        }
                                )
                                Spacer()
                            }
                            .frame(height: collapsedHeight)
                        }
                        .contentShape(Rectangle())
                        .onHover { hovering in
                            if hovering {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    isExpanded = true
                                }
                            }
                        }
                        // Expanded content
                        if isExpanded {
                            VStack(spacing: 0) {
                                Spacer(minLength: 16)
                                HStack(spacing: 16) {
                                    // Music widget (Notch Hook style)
                                    PillWidget(
                                        icon: nil,
                                        iconColor: nil,
                                        label: "West End Blues\nLouis Armstrong",
                                        minWidth: 160, maxWidth: 220, height: 56, multiline: true, expanded: hoveredWidget == 0, leadingImage: Image("albumart")
                                    ) {
                                        HStack(spacing: 8) {
                                            Button(action: {}) {
                                                Image(systemName: "backward.fill")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                            Button(action: {}) {
                                                Image(systemName: "play.fill")
                                                    .font(.system(size: 15, weight: .bold))
                                                    .foregroundColor(.white.opacity(0.9))
                                            }
                                            Button(action: {}) {
                                                Image(systemName: "forward.fill")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                        }
                                    }
                                    .onHover { hoveredWidget = $0 ? 0 : nil }
                                    // AI Chat widget (center, chat input style)
                                    PillWidget(icon: "sparkles", iconColor: .yellow, label: "Ask anything...", minWidth: 200, maxWidth: 320, height: 56, glow: true, expanded: hoveredWidget == 1) {
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.yellow.opacity(0.7))
                                            .padding(.leading, 2)
                                    }
                                    .onHover { hoveredWidget = $0 ? 1 : nil }
                                    // Time widget (right)
                                    PillWidget(icon: "clock.fill", iconColor: .blue, label: timeString, minWidth: 120, maxWidth: 180, height: 56, glow: true, expanded: hoveredWidget == 2) {
                                        Text(dateString)
                                            .font(.system(size: 12, weight: .regular, design: .rounded))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    .onHover { hoveredWidget = $0 ? 2 : nil }
                                }
                                Spacer(minLength: 16)
                            }
                            .padding(.horizontal, 40)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .frame(width: width, height: expandedHeight, alignment: .top)
                }
                .clipShape(ExpandableIslandShape(expansion: isExpanded ? 1 : 0))
                .frame(width: width, height: expandedHeight, alignment: .top)
            }
            .frame(width: width, height: expandedHeight, alignment: .top)
            .offset(x: dragOffset)
            .onHover { hovering in
                if !hovering {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isExpanded = false
                    }
                }
            }
        }
        .frame(width: width, height: expandedHeight)
    }
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter.string(from: Date())
    }
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ExpandableIslandView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
