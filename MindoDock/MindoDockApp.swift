import SwiftUI
import AppKit

@main
struct MindoDockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 700, height: 140)
                .background(.clear)
                .ignoresSafeArea()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    static var shared: AppDelegate?
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        AppDelegate.shared = self
        if let window = NSApplication.shared.windows.first {
            self.window = window
            window.level = .floating
            window.collectionBehavior = [.canJoinAllSpaces, .stationary]
            window.isOpaque = false
            window.backgroundColor = .clear
            window.hasShadow = false
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.ignoresMouseEvents = false
            window.acceptsMouseMovedEvents = true
            // Always position window at the very top center of the main screen
            if let screen = NSScreen.main {
                let windowWidth: CGFloat = 700
                let windowHeight: CGFloat = 140
                let xPosition = (screen.frame.width - windowWidth) / 2
                let yPosition = screen.frame.maxY - windowHeight
                window.setFrame(NSRect(x: xPosition, y: yPosition, width: windowWidth, height: windowHeight), display: true, animate: false)
            }
        }
    }
    // Allow SwiftUI to update the window's x-position
    static func setWindowX(_ x: CGFloat) {
        guard let window = AppDelegate.shared?.window, let screen = NSScreen.main else { return }
        let windowWidth: CGFloat = 700
        let windowHeight: CGFloat = 140
        let yPosition = screen.frame.maxY - windowHeight
        let clampedX = min(max(0, x), screen.frame.width - windowWidth)
        window.setFrame(NSRect(x: clampedX, y: yPosition, width: windowWidth, height: windowHeight), display: true, animate: false)
    }
}
