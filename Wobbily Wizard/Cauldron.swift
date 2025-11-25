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
    @State private var showShakeCount = false
    @State private var isBrewing = false
    
    @EnvironmentObject var playerData: PlayerData
    

    let items = ["🌻", "🌶️", "🌡️", "🧨", "🔌", "🔋", "⚡", "📱", "🐍", "🧪", "💀", "☢️", "🧊", "🍨", "🥶", "🐧"]
    let emojiToName: [String : String] = [
        "🌻": "Sunflower",
        "🌶️": "Hot Pepper",
        "🌡️": "Thermometer",
        "🧨": "Fire Cracker",
        "🔌": "Cable",
        "🔋": "Battery",
        "⚡": "Lightning",
        "📱": "Device",
        "🐍": "Snake",
        "🧪": "Vial",
        "💀": "Skull",
        "☢️": "Nuclear Waste",
        "🧊": "Ice Cube",
        "🍨": "Ice Cream",
        "🥶": "Frozen Fred",
        "🐧": "Penguin"
    ]
    
    func checkRecipe(items: [String]) -> Bool{
        var valid_potion = false
        if Set(items) == Set(["🌻", "🌶️", "🌡️", "🧨"]){
            valid_potion = true
            brewPotionType = "Fire"
        }
        else if Set(items) == Set(["🔌", "🔋", "⚡", "📱"]){
            valid_potion = true
            brewPotionType = "Electric"
        }
        else if Set(items) == Set(["🐍", "🧪", "💀", "☢️"]){
            valid_potion = true
            brewPotionType = "Poison"
        }
        else if Set(items) == Set(["🧊", "🍨", "🥶", "🐧"]){
            valid_potion = true
            brewPotionType = "Ice"
        }
        return valid_potion
    }
    func reset_pot(){
        for item in droppedItems{
            addItemUsingEmoji(item)
        }
        droppedItems.removeAll()
    }
    func addItemUsingEmoji(_ emoji: String) {
        if let name = emojiToName[emoji] {
            playerData.addItem(name)
        }
    }
    func inInventory(item: String) -> Bool {
        guard let name = emojiToName[item] else { return false }

        for inventoryItem in playerData.inventory {
            if inventoryItem.name == name && inventoryItem.amount > 0 {
                return true
            }
        }
        return false
    }
    func brewPotion() {
        // Final animation
        cauldronImage = "shaking_1"
        showShakeCount = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cauldronImage = "shaking_2"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            cauldronImage = "cauldron"
            
            showPotionBrewedAlert = true
            reset_pot()
            
            shakeCount = 0   // Reset for next brew
            showShakeCount = false
        }
    }
    func decreaseItemUsingEmoji(_ emoji: String) {
        if let name = emojiToName[emoji] {
            playerData.decreaseItem(name)
        }
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 20) {
                ForEach(items, id: \.self) { item in
                    if(inInventory(item: item)){
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

                                    if inInventory(item: item) {

                                        // Prevent duplicates in the pot
                                        if droppedItems.contains(item) {
                                            missingItemName = "already added \(emojiToName[item] ?? item)"
                                            showMissingItemAlert = true
                                            return
                                        }

                                        // ✔ Safe to add
                                        droppedItems.append(item)
                                        decreaseItemUsingEmoji(item)

                                    } else {
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
                    
                    guard isBrewing else { return }   // ⬅ ONLY shake AFTER pressing Brew
                    
                    if droppedItems.count == 4 && checkRecipe(items: droppedItems) {
                            shakeCount += 1
                            showShakeCount = true
 
                            cauldronImage = (shakeCount % 2 == 0) ? "shaking_1" : "shaking_2"
                            
                            if shakeCount == 10 {
                                brewPotion()
                            }
                        }
                }
            HStack{
                Button("Reset"){
                    reset_pot()
                    
                }
                .disabled(droppedItems.isEmpty)
                .padding(7)
                .font(.title3)
                .background(Color.white)
                .cornerRadius(10)
                Spacer()
                Text("Shake Progress: \(shakeCount)/10")
                    .font(.headline)
                    .padding(.top, 10)
                    .background(Color.white)
                    .opacity(showShakeCount ? 1 : 0)
                Spacer()
                Button("Brew"){
                    isBrewing = true
                    showShakeCount = true
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
                .offset(x: -100, y: 0)
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
