//
//  ContentView.swift
//  JotDownWatch Watch App
//
//  Created by Joseph Masson on 9/26/25.
//

import SwiftUI


struct ContentView: View {
    @State private var showingInput = false
    @State private var thoughtInput = ""

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
                            // TODO save to swift data
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
                // TODO fetch from swift data
                // ForEach(thoughts, id: \ .self) { thought in
                //     Text(thought)
                //         .font(.body)
                // }
             }
            .tag(1)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ContentView()
}
