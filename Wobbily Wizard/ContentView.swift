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
                TabView() {
                    Home().tabItem() {
                        Label("Home", systemImage: "house.fill")
                    }
                    Cauldren().tabItem {
                        Label("Cauldron", systemImage: "wand.and.stars")
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
