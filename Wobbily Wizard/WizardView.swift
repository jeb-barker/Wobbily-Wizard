//
//  ContentView.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI

extension UIDevice {
    static let deviceDidShake = Notification.Name(rawValue: "deviceDidShake")
}
class CustomWindow: UIWindow {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            guard motion == .motionShake else { return }
            NotificationCenter.default.post(name: UIDevice.deviceDidShake, object: nil)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
extension View {
    public func onShakeGesture(perform action: @escaping () -> Void) -> some View {
        self.modifier(ShakeGestureViewModifier(action: action))
    }
}
enum Screen {
    case home
    case cauldron
    case friends
}
struct ShakeGestureViewModifier: ViewModifier {
  // 1
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content
      // 2
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShake)) { _ in
        action()
      }
  }
}
struct WizardView: View {
    @State private var currentView : Screen = .home
    @StateObject var shopData = ShopData()
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView() {
                    Home().tabItem() {
                        Label("Home", systemImage: "house.fill")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.white, for: .tabBar)
                    Cauldren().tabItem {
                        Label("Cauldron", systemImage: "wand.and.stars")
                    }
                    Friends().tabItem(){
                        Label("Friends", systemImage: "person.2")
                    }
                    Shop().environmentObject(shopData).tabItem() {
                        Label("Shop", systemImage: "cart.fill")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.white, for: .tabBar)

                }.backgroundStyle(FillShapeStyle())
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
            Text("")
                .onShakeGesture{
                    print("Device is shaking!")
                }
        }
        .padding()
    }
}
struct Friends: View{
    var body: some View{
        //hardcoded array of UIDs, ideally backend would exist to store usernames and UIDs
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let arr = [id1, id2, id3]
        VStack{
            Text("Friends List")
            ForEach(arr, id: \.self){ userId in
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red)
                        .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight * 0.13, alignment: .center)
                    VStack{
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
}
#Preview {
    WizardView()
}
