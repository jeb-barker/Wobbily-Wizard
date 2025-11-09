//
//  Cauldron.swift
//  Wobbily Wizard
//
//  Created by Ashley Kulcsar on 11/7/25.
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

extension View {
    public func onShakeGesture(perform action: @escaping () -> Void) -> some View {
        self.modifier(ShakeGestureViewModifier(action: action))
    }
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
struct Cauldren: View {
    @State private var droppedItems: [String] = []
    @State private var shaken: Int = 0

    let items = ["🌻", "🌶️", "🌡️", "🧨", "🔌", "🔋", "⚡", "📱", "🐍", "🧪", "💀", "☢️", "🧊", "🍨", "🥶", "🐧"]
    
    func checkRecipe(items: [String]) -> (Bool, String){
        var valid_potion = false
        var type = "None"
        if items == ["🌻", "🌶️", "🌡️", "🧨"] {
            valid_potion = true
            type = "Fire"
        }
        else if items == ["🔌", "🔋", "⚡", "📱"] {
            valid_potion = true
            type = "Lightning"
        }
        else if items == ["🐍", "🧪", "💀", "☢️"] {
            valid_potion = true
            type = "Poison"
        }
        else if items == ["🧊", "🍨", "🥶", "🐧"] {
            valid_potion = true
            type = "Ice"
        }
        return (valid_potion, type)
    }
    func reset_pot() -> [String]{
        return []
    }
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 20) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.title)
                        .frame(width: 45, height: 45)
                        .background(Color.brown.opacity(0.3))
                        .cornerRadius(10)
                        .onDrag {
                            return NSItemProvider(object: item as NSString)
                        }
                }
            }
            Spacer()
            
            // Drop target (the cauldron)
            Image("cauldron")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 150)
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
            Text("In The Pot: \(droppedItems.joined(separator: ", "))")
                .padding(.top, 30)
            Text("")
                .onShakeGesture{
                    print("Device is shaking!")
                }
            HStack{
                Button("Reset"){
                    print("hello world")
                    
                }
                .disabled(droppedItems.isEmpty)
                Spacer()
                Button("Brew"){
                    print("hello world")
                }
                .disabled(droppedItems.isEmpty)
            }
            
        }
        .padding()
        .background(
            Image("Cauldron_Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: -80)
        )
    }
}
#Preview {
    Cauldren()
}
