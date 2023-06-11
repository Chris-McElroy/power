//
//  powerApp.swift
//  power
//
//  Created by Chris McElroy on 12/28/22.
//

import SwiftUI


@main
struct powerApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
    var body: some Scene {
		WindowGroup(id: "main") {
            ContentView()
        }
		.windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
	func applicationWillFinishLaunching(_ notification: Notification) {
		// https://stackoverflow.com/questions/70091919/how-set-position-of-window-on-the-desktop-in-swiftui
		UserDefaults.standard.set("0 0 10 38 0 0 1512 950 ", forKey: "NSWindow Frame main-AppWindow-1")
	} // 0 0 10 38 0 0 1512 950 for me, 0 0 13 41 0 0 1512 950 for vera
	
	func applicationDidFinishLaunching(_ notification: Notification) {
		if let window = NSApplication.shared.windows.first {
			window.titleVisibility = .hidden
			window.titlebarAppearsTransparent = true
			window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
			window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
			window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
			window.isOpaque = false
			window.hasShadow = false
			window.level = .floating
			window.backgroundColor = NSColor.clear
			window.isReleasedWhenClosed = false
			window.isMovableByWindowBackground = false
			window.titlebarSeparatorStyle = .none
			window.ignoresMouseEvents = true
			window.delegate = self
			Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
				// i have no fucking clue why this delay seems to be necessary
				window.collectionBehavior = .canJoinAllSpaces
			})
		}
		
		return
	}
}
