//
//  Cauldron.swift
//  Wobbily Wizard
//
//  Created by Ashley Kulcsar on 11/7/25.
//

import SwiftUI

struct Cauldren: View {
    @State private var droppedItems: [String] = []

    let items = ["🌻", "🌶️", "🌡️", "🧨", "🔌", "🔋", "⚡", "📱", "🐍", "🧪", "💀", "☢️", "🧊", "🍨", "🥶", "🐧"]
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
            Text("In The Pot: \(droppedItems.joined(separator: ", "))")
                .padding(.top, 30)
            Text("")
                .onShakeGesture{
                    print("Device is shaking!")
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
