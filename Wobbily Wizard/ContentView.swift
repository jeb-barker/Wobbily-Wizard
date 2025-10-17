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
    @State private var droppedItems: [String] = []

    let items = ["🍎", "🌿", "💎", "🐍", "🍔", "🍕", "🍜", "🌮", "🍣", "🥗", "💀", "🧪", "⛧", "🖤", "🕯️", "⚗️"]

    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .background(Color.brown.opacity(0.3))
                        .cornerRadius(10)
                        .onDrag {
                            return NSItemProvider(object: item as NSString)
                        }
                }
            }
            .padding(.top, 40)

            Spacer()
            
            // Drop target (the cauldron)
            Image("cauldren-1")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .onDrop(of: [.text], isTargeted: nil) { providers in
                    for provider in providers {
                        _ = provider.loadObject(ofClass: String.self) { (string, _) in
                            if let item = string {
                                DispatchQueue.main.async {
                                    droppedItems.append(item)
                                }
                            }
                        }
                    }
                    return true
                }

            // Show what’s been dropped
            Text("Dropped: \(droppedItems.joined(separator: ", "))")
                .padding(.top, 20)
        }
        .padding()
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
