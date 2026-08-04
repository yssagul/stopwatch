import Cocoa

final class StopwatchController: NSObject {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var timer: Timer?
    private var accumulated: TimeInterval = 0
    private var startDate: Date?

    private var isRunning: Bool { startDate != nil }

    override init() {
        super.init()
        statusItem.button?.title = "00:00"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(handleClick)
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    @objc private func handleClick() {
        let event = NSApp.currentEvent
        let wantsMenu = event?.type == .rightMouseUp || event?.modifierFlags.contains(.option) == true
        if wantsMenu {
            showMenu()
        } else {
            toggle()
        }
    }

    private func toggle() {
        if isRunning {
            accumulated += Date().timeIntervalSince(startDate!)
            startDate = nil
            timer?.invalidate()
            timer = nil
        } else {
            startDate = Date()
            let t = Timer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
            RunLoop.main.add(t, forMode: .common)
            timer = t
        }
        updateTitle()
    }

    @objc private func tick() {
        updateTitle()
    }

    private func currentElapsed() -> TimeInterval {
        accumulated + (startDate.map { Date().timeIntervalSince($0) } ?? 0)
    }

    private func updateTitle() {
        let total = Int(currentElapsed())
        let minutes = total / 60
        let seconds = total % 60
        statusItem.button?.title = String(format: "%02d:%02d", minutes, seconds)
    }

    private func showMenu() {
        let menu = NSMenu()
        menu.addItem(withTitle: "Clear", action: #selector(clear), keyEquivalent: "").target = self
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "q").target = self
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    @objc private func clear() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        accumulated = 0
        updateTitle()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let controller = StopwatchController()
app.run()
