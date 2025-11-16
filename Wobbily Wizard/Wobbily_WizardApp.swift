//
//  Wobbily_WizardApp.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }

}

@main
struct Wobbily_WizardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var playerData = PlayerData()
    
    var body: some Scene {
        WindowGroup {
            if(playerData.hasSeenLanding == false){
                Landing()
                    .environmentObject(playerData)
            }
            else{
                WizardView()
                    .environmentObject(playerData)
            }
        }
    }
}
