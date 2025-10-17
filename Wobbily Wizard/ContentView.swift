//
//  ContentView.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
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
                    Friends().tabItem(){
                        Label("Friends", systemImage: "person.2")
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
struct Friends: View{
    var body: some View{
        //hardcoded array of UIDs, ideally backend would exist to store usernames and UIDs
        var id1 = UUID()
        var id2 = UUID()
        var id3 = UUID()
        var arr = [id1, id2, id3]
        Text("Friends List")
        VStack{
            ForEach(arr, id: \.self){ userId in
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.black)
                        .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight * 0.13, alignment: .center)
                    Text("Nickname")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                    Text(userId.uuidString)
                        .font(.caption)
                }
                    
            }
        }
        
    }
}
#Preview {
    ContentView()
}
