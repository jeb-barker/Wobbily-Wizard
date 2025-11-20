//
//  Wobbily_WizardApp.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
      let providerFactory = AppCheckDebugProviderFactory()
      AppCheck.setAppCheckProviderFactory(providerFactory)

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
