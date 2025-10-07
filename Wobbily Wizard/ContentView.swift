//
//  ContentView.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI


enum Screen {
    case home
    case cauldron
    case friends
}

struct ContentView: View {
    @State private var currentView : Screen = .home
    
    var body: some View {
        NavigationStack {
            VStack {
                switch currentView {
                case .home:
                    Home()
                case .cauldron:
                    Cauldren()
                case .friends:
                    Text("friends")
                }
            }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {currentView = .home}) {
                            Label("Home", systemImage: "house")
                        }
                        Spacer()
                        Button(action: {currentView = .cauldron}) {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        Spacer()
                        Button(action: {currentView = .friends}) {
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
struct Shop: View {
    var body: some View {
        Text("Hello. Shop!")
    }
}

#Preview {
    ContentView()
}
