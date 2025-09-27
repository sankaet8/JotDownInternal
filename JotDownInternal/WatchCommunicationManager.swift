import WatchConnectivity
import SwiftData
import SwiftUI

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    var modelContext: ModelContext?

    func setup(context: ModelContext) {
        self.modelContext = context
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("WCSession activated")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let text = message["thought"] as? String, !text.isEmpty {
            print("Received thought: \(text)")
            Task { @MainActor in
                let thought = Thought(text: text)
                modelContext?.insert(thought)
                try? modelContext?.save()
            }
            replyHandler([:]) // Optionally acknowledge
            return
        }

        if message["request"] as? String == "thoughts" {
            let thoughts = fetchThoughts()
            replyHandler(["thoughts": thoughts])
            return
        }
    }

    func fetchThoughts() -> [String] {
        guard let context = modelContext else { return [] }
        let descriptor = FetchDescriptor<Thought>()
        let results = (try? context.fetch(descriptor)) ?? []
        return results.map { $0.text }
    }

    // Required delegate stubs
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
