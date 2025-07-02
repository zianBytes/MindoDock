//
//  MindoDockApp.swift
//  MindoDock
//
//  Created by Zian Miad on 7/2/25.
//
import SwiftUI

@main
struct MindoDockApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 600, height: 120)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding()
        }
        .windowStyle(HiddenTitleBarWindowStyle()) // No title bar
    }
}

// Make the dock float and stay in all spaces
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.level = .floating // Always stays above other windows
            window.collectionBehavior = [.canJoinAllSpaces, .stationary]
            window.isOpaque = false
            window.backgroundColor = .clear
        }
    }
}
