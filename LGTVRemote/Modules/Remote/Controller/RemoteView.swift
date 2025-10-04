
import SwiftUI

// MARK: - Main Remote View
/// The main container view for the remote control interface.
struct RemoteView: View {
    /// A struct to hold all the callback actions for the remote buttons.
    /// This decouples the view from the business logic.
    struct Actions {
        var onPower: () -> Void = {}
        var onConnectDevice: () -> Void = {}
        var onBack: () -> Void = {}
        var onHome: () -> Void = {}
        var onMute: () -> Void = {}
        var onKeyboard: () -> Void = {}
        var onDialPad: () -> Void = {}
        var onMenu: () -> Void = {}
        var onRewind: () -> Void = {}
        var onPlay: () -> Void = {}
        var onForward: () -> Void = {}
        var onChannelDown: () -> Void = {}
        var onChannelUp: () -> Void = {}
        var onVolumeDown: () -> Void = {}
        var onVolumeUp: () -> Void = {}
        var onOK: () -> Void = {}
        var onUp: () -> Void = {}
        var onDown: () -> Void = {}
        var onLeft: () -> Void = {}
        var onRight: () -> Void = {}
        var onViewAction: (ViewAction) -> Void = { _ in }
    }

    let actions: Actions
    
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Color.init(uiColor: UIColor(hex: "010101")).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25.dp) {
//                    TopBarView(onPower: actions.onPower, onConnectDevice: actions.onConnectDevice)
                    StandardControlsView(actions: actions)
                    ChannelAndVolumeView(
                        onChannelDown: actions.onChannelDown,
                        onChannelUp: actions.onChannelUp,
                        onVolumeDown: actions.onVolumeDown,
                        onVolumeUp: actions.onVolumeUp
                    )
                    
                    if selectedTab == 0 {
                        DirectionalPadView(
                            onOK: actions.onOK,
                            onUp: actions.onUp,
                            onDown: actions.onDown,
                            onLeft: actions.onLeft,
                            onRight: actions.onRight
                        )
                    } else {
                        TouchpadViewRepresentable()
                            .frame(height: 200.dp)
                    }
                    
                    DeviceSelectionView { index in
                        selectedTab = index
                    }
                    .padding(.bottom, 20.dp)
                }
                .padding(.horizontal, 25.dp)
            }
        }
        .foregroundColor(.white)
    }
}

// MARK: - Top Bar Section
private struct TopBarView: View {
    let onPower: () -> Void
    let onConnectDevice: () -> Void

    var body: some View {
        HStack {
            Button(action: onPower) {
                Image(systemName: "power")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(12)
                    .background(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1))
            }
            Spacer()
            Button(action: onConnectDevice) {
                HStack {
                    Text("Connect device")
                    Image(systemName: "wifi")
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.15))
                .clipShape(Capsule())
            }
        }
    }
}

// MARK: - 3x3 Grid Controls
private struct StandardControlsView: View {
    let actions: RemoteView.Actions
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20.dp) {
            RemoteCircleButton(icon: "arrow.uturn.backward") {
                actions.onViewAction(.tvCommand(.back))
            }
            RemoteCircleButton(icon: "house.fill") {
                actions.onViewAction(.tvCommand(.home))
            }
            RemoteCircleButton(icon: "speaker.slash.fill") {
                actions.onViewAction(.tvCommand(.mute))
            }
            RemoteCircleButton(icon: "keyboard", action: actions.onKeyboard)
            DialPadButton(action: actions.onDialPad)
            RemoteCircleButton(text: "Menu") {
                actions.onViewAction(.tvCommand(.menu))
            }
            RemoteCircleButton(icon: "backward.fill") {
                actions.onViewAction(.tvCommand(.rewind))
            }
            RemoteCircleButton(icon: "play.fill") {
                actions.onViewAction(.tvCommand(.play))
            }
            RemoteCircleButton(icon: "forward.fill") {
                actions.onViewAction(.tvCommand(.fastForward))
            }
        }
        .padding(.horizontal, 20.dp)
    }
}

// MARK: - Channel and Volume Section
private struct ChannelAndVolumeView: View {
    let onChannelDown: () -> Void
    let onChannelUp: () -> Void
    let onVolumeDown: () -> Void
    let onVolumeUp: () -> Void
    
    var body: some View {
        HStack(spacing: 20.dp) {
            HStack {
                Button(action: onChannelDown) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 18.dp, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 30.dp)
                        .contentShape(Rectangle())
                }
                Text("CH").font(Font.appFont(ofSize: 16.dp, weight: .medium))
                Button(action: onChannelUp) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 18.dp, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 30.dp)
                        .contentShape(Rectangle())
                }
            }
            .modifier(ChannelVolumeModifier())
            
            HStack {
                Button(action: onVolumeDown) {
                    Image(systemName: "minus")
                        .font(.system(size: 18.dp, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 30.dp)
                        .contentShape(Rectangle())
                }
                Text("vol").fontWeight(.bold)
                Button(action: onVolumeUp) {
                    Image(systemName: "plus")
                        .font(.system(size: 18.dp, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 30.dp)
                        .contentShape(Rectangle())
                }
            }
            .modifier(ChannelVolumeModifier())
        }
    }
}

// MARK: - Directional Pad Section
private struct DirectionalPadView: View {
    let onOK: () -> Void
    let onUp: () -> Void
    let onDown: () -> Void
    let onLeft: () -> Void
    let onRight: () -> Void
    
    private let viewSize: CGFloat = 250.dp
    private let arrowOffset: CGFloat = 100.dp

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [.init(uiColor: UIColor(hex: "#181818")), .init(uiColor: UIColor(hex: "#262626"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                .overlay(
                    // The gradient border
                    RoundedRectangle(cornerRadius: viewSize / 2)
                        .stroke(
                            LinearGradient(
                                colors: [.white, .clear, .clear, .white],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .frame(width: viewSize, height: viewSize)

            Button(action: onOK) {
                Text("OK")
                    .font(.appFont(ofSize: 22.dp, weight: .bold))
                    .frame(width: (viewSize * 0.45), height: (viewSize * 0.45))
                    .background(LinearGradient(
                        colors: [Color.init(uiColor: UIColor(hex: "FFDAC4", alpha: 0.9)),
                                 Color.init(uiColor: UIColor(hex: "FC3C74")),
                                 Color.init(uiColor: UIColor(hex: "FF3138"))],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .clipShape(Circle())
                    .shadow(color: .red.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            
            ArrowButton(icon: "chevron.up", offset: .init(width: 0, height: -arrowOffset), action: onUp)
            ArrowButton(icon: "chevron.down", offset: .init(width: 0, height: arrowOffset), action: onDown)
            ArrowButton(icon: "chevron.left", offset: .init(width: -arrowOffset, height: 0), action: onLeft)
            ArrowButton(icon: "chevron.right", offset: .init(width: arrowOffset, height: 0), action: onRight)
        }
        .frame(height: viewSize)
    }
}

private struct ArrowButton: View {
    let icon: String
    let offset: CGSize
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.appFont(ofSize: 25.dp, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 60.dp, height: 60.dp)
        }
        .background(Color.clear)
        .offset(offset)
    }
}

// MARK: - Bottom Device Selection
private struct DeviceSelectionView: View {
    let onDeviceSelected: (Int) -> Void
    @State private var selectedIndex = 0
    private let icons = ["viewfinder", "desktopcomputer"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<icons.count, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                    onDeviceSelected(index)
                }) {
                    Image(systemName: icons[index])
                        .font(.title2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            Group {
                                if selectedIndex == index {
                                    Capsule()
                                        .fill(Color.white.opacity(0.25))
                                        .padding(5)
                                        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 3)
                                }
                            },
                            alignment: .center
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 180.dp, height: 50.dp)
        .background(LinearGradient(colors: [.init(uiColor: UIColor(hex: "#181818")), .init(uiColor: UIColor(hex: "#262626"))], startPoint: .topLeading, endPoint: .bottomTrailing))
        .overlay(
            // The gradient border
            RoundedRectangle(cornerRadius: 25.dp)
                .stroke(
                    LinearGradient(
                        colors: [.white, .clear, .clear, .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(Capsule())
//        .padding(.horizontal, 60)
    }
}

// MARK: - Reusable Components & Modifiers
private struct RemoteCircleButton: View {
    var icon: String?
    var text: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if let icon = icon {
                    Image(systemName: icon).font(.appFont(ofSize: 20.dp, weight: .bold))
                }
                if let text = text {
                    Text(text).font(.appFont(ofSize: 14.dp, weight: .regular))
                }
            }
            .frame(width: 60.dp, height: 60.dp)
            .background(LinearGradient(colors: [.init(uiColor: UIColor(hex: "#181818")), .init(uiColor: UIColor(hex: "#262626"))], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                // The gradient border
                RoundedRectangle(cornerRadius: 30.dp)
                    .stroke(
                        LinearGradient(
                            colors: [.white, .clear, .clear, .white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            .clipShape(Circle())
        }
    }
}

private struct DialPadButton: View {
    let action: () -> Void
    private let dimen: CGFloat = 8.dp

    var body: some View {
        Button(action: action) {
            HStack(spacing: 3) {
                Circle().fill(Color.blue).frame(width: dimen, height: dimen)
                Circle().fill(Color.red).frame(width: dimen, height: dimen)
                Circle().fill(Color.yellow).frame(width: dimen, height: dimen)
                Circle().fill(Color.green).frame(width: dimen, height: dimen)
            }
            .frame(width: 60.dp, height: 60.dp)
            .background(Color.white.opacity(0.15))
            .clipShape(Circle())
        }
    }
}

private struct ChannelVolumeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60.dp)
            .background(LinearGradient(colors: [.init(uiColor: UIColor(hex: "#181818")), .init(uiColor: UIColor(hex: "#262626"))], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                // The gradient border
                RoundedRectangle(cornerRadius: 30.dp)
                    .stroke(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.1), .clear, .clear, .clear, .clear, .white.opacity(0.1), .white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .clipShape(Capsule())
            .buttonStyle(.plain) // Ensures the whole area isn't tappable
    }
}

// MARK: - Preview
//struct RemoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Provide a dummy Actions struct for the preview to work.
//        RemoteView(actions: .init())
//    }
//}
