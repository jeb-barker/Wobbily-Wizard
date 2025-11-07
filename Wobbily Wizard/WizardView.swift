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
    @StateObject var itemData = ItemData()
    
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
                    Shop().environmentObject(itemData).tabItem() {
                        Label("Shop", systemImage: "cart.fill")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.white, for: .tabBar)

                }.backgroundStyle(FillShapeStyle())
            }
            
            
        }
    }
}

#Preview {
    WizardView().environmentObject(ItemData())
}
