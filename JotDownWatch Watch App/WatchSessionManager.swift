//
//  WatchSessionManager.swift
//  JotDownInternal
//
//  Created by Joseph Masson on 9/26/25.
//

import Foundation
import WatchConnectivity
import Combine

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    @Published var thoughts: [String] = []

    override init() {
        super.init()
        activateSession()
    }

    private func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func requestThoughts() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["request": "thoughts"], replyHandler: { response in
                if let receivedThoughts = response["thoughts"] as? [String] {
                    DispatchQueue.main.async {
                        self.thoughts = receivedThoughts
                    }
                }
            }, errorHandler: { error in
                print("Error requesting thoughts: \(error.localizedDescription)")
            })
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            requestThoughts()
        }
    }

    // Required stub
    func session(_ session:WCSession, didReceiveMessage message: [String: Any]) {}
}
