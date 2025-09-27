//
//  ContentView.swift
//  JotDownWatch Watch App
//
//  Created by Joseph Masson on 9/26/25.
//

import SwiftUI
import WatchConnectivity


struct ContentView: View {
    @State private var showingInput = false
    @State private var thoughtInput = ""
    @ObservedObject  var watchSessionManager = WatchSessionManager.shared
    
    var body: some View {
        TabView {
            VStack {
                Spacer()
                Button(action: {
                    showingInput = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showingInput) {
                    VStack {
                        Text("New Thought")
                            .font(.headline)
                        TextField("Enter your thought", text: $thoughtInput)
                            .padding()
                        Button("Save") {
                            let message = ["thought": thoughtInput]
                            if WCSession.default.isReachable {
                                WCSession.default.sendMessage(message, replyHandler: { _ in}, errorHandler: { error in
                           
                                    print("Error sending message: \(error.localizedDescription)")
                                })
                                thoughtInput = ""
                                showingInput = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .padding()
                }
                Spacer()
            }
            .tag(0)

            List {
                if watchSessionManager.thoughts.isEmpty {
                    Text("No thoughts written yet!")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(watchSessionManager.thoughts, id: \.self) { thought in
                        Text(thought)
                            .font(.body)
                    }
                }
             }
            .tag(1)
            // .onAppear {
            //     watchSessionManager.requestThoughts()
            // }
        }
        .tabViewStyle(.page)
        .onAppear {
            if WCSession.isSupported() {
                WCSession.default.delegate = WatchSessionManager.shared
                WCSession.default.activate()
                watchSessionManager.requestThoughts()
            }
        }
    }
}

#Preview {
    ContentView()
}
