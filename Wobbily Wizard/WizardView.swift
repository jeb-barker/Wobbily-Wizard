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
    case landing
    case home
    case cauldron
    case friends
}

struct WizardView: View {
    @State private var currentView : Screen = .home
    @StateObject var itemData = ItemData()
    @EnvironmentObject var playerData: PlayerData
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView() {
                    Home().tabItem() {
                        Label("Home", systemImage: "house.fill")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.white, for: .tabBar)
                    .environmentObject(playerData)
                    Cauldren().tabItem {
                        Label("Cauldron", systemImage: "wand.and.stars")
                    }
                    Friends().tabItem(){
                        Label("Friends", systemImage: "person.2")
                    }
                    Shop().environmentObject(itemData).environmentObject(playerData).tabItem() {
                        Label("Shop", systemImage: "cart.fill")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(Color.white, for: .tabBar)

                }
                .backgroundStyle(FillShapeStyle())
                .onAppear{
                    playerData.hasSeenLanding = true
                }
                .onChange(of: playerData.inventory) { _ in playerData.save() }
                .onChange(of: playerData.potions) { _ in playerData.save() }
                .onChange(of: playerData.balance) { _ in playerData.save() }
                .navigationBarBackButtonHidden(true)
            }
            
            
        }
    }
}

#Preview {
    WizardView()
        .environmentObject(PlayerData())
}
