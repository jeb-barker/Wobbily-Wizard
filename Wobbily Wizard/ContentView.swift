//
//  ContentView.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {}) {
                            Label("Home", systemImage: "house")
                        }
                        Spacer()
                        Button(action: {}) {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        Spacer()
                        Button(action: {}) {
                            Label("Profile", systemImage: "person.circle")
                        }
                    }
                }
            }
    }
}
struct Cauldren: View {
    var body: some View {
        Text("Hello, Cauldren!")
    }
}

#Preview {
    ContentView()
}
