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
    @State private var showMissingItemAlert = false
    @State private var showPotionBrewedAlert = false
    @State private var missingItemName = ""
    @State private var brewPotionType = ""
    @State private var shakeCount = 0
    @State private var cauldronImage = "cauldron"
    
    @EnvironmentObject var playerData: PlayerData
    

    let items = ["🌻", "🌶️", "🌡️", "🧨", "🔌", "🔋", "⚡", "📱", "🐍", "🧪", "💀", "☢️", "🧊", "🍨", "🥶", "🐧"]
    
    func checkRecipe(items: [String]) -> Bool{
        var valid_potion = false
        if items == ["🌻", "🌶️", "🌡️", "🧨"] {
            valid_potion = true
            brewPotionType = "Fire"
        }
        else if items == ["🔌", "🔋", "⚡", "📱"] {
            valid_potion = true
            brewPotionType = "Electric"
        }
        else if items == ["🐍", "🧪", "💀", "☢️"] {
            valid_potion = true
            brewPotionType = "Poison"
        }
        else if items == ["🧊", "🍨", "🥶", "🐧"] {
            valid_potion = true
            brewPotionType = "Ice"
        }
        return valid_potion
    }
    func reset_pot() -> [String]{
        return []
    }
    func inInventory(item:String) -> Bool{
        // loop through player data to find the item
        for inventoryItem in playerData.inventory {
            if inventoryItem.name == item {
                if inventoryItem.amount > 0 {
                    return true
                }
            }
        }
        return false
    }
    func brewPotion(){
        shakeCount = 0
        while shakeCount < 10 {
            if shakeCount % 2 == 0 {
                cauldronImage = "shaking_1"
            }
            else {
                cauldronImage = "shaking_2"
            }
        }
        cauldronImage = "cauldron"
        showPotionBrewedAlert = true
        droppedItems = reset_pot()
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
            Image(cauldronImage)
                .resizable()
                .scaledToFit()
                .padding(.bottom, 10)
                .frame(width: 250, height: 150)
                .onDrop(of: [.text], isTargeted: nil) { providers in
                    for provider in providers {
                        _ = provider.loadObject(ofClass: String.self) { (string, _) in
                            if let item = string {
                                DispatchQueue.main.async {
                                    if(inInventory(item: item)){
                                        droppedItems.append(item)
                                    }
                                    else{
                                        missingItemName = item
                                        showMissingItemAlert = true
                                    }
                                }
                            }
                        }
                    }
                    return true
                }

            // Show what’s been dropped
            Text("In The Pot: \(droppedItems.joined(separator: ", "))")
                .padding(10)
                .font(.title3)
                .background(Color.white)
                .cornerRadius(10)
                
            Text("")
                .onShakeGesture{
                    shakeCount += 1
                }
            HStack{
                Button("Reset"){
                    droppedItems = reset_pot()
                    
                }
                .disabled(droppedItems.isEmpty)
                .padding(7)
                .font(.title3)
                .background(Color.white)
                .cornerRadius(10)
                Spacer()
                Button("Brew"){
                    brewPotion()
                }
                .disabled(!checkRecipe(items: droppedItems))
                .padding(7)
                .font(.title3)
                .background(Color.white)
                .cornerRadius(10)
            }
            
        }
        .padding()
        .background(
            Image("Cauldron_Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: -170)
        )
        .alert("Item Missing",
               isPresented: $showMissingItemAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Nope — you don't have \(missingItemName) in your inventory.")
        }
        .alert("Potion Brewed",
               isPresented: $showPotionBrewedAlert) {
            Button("OK", role: .cancel){ }
        } message: {
            Text("You have successfully brewed \(brewPotionType)! It is now in your inventory.")
        }
    }
}
#Preview {
    Cauldren().environmentObject(PlayerData())
}
