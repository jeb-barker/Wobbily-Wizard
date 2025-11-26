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

    func application(_ application: UIApplication,
                         configurationForConnecting connectingSceneSession: UISceneSession,
                         options: UIScene.ConnectionOptions) -> UISceneConfiguration {

            let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)

            // Tell iOS to use our SceneDelegate
            config.delegateClass = SceneDelegate.self
            return config
        }

}

@main
struct Wobbily_WizardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var playerData = PlayerData()
    @StateObject var stepModel = StepCountViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                if(playerData.hasSeenLanding == false){
                    Landing()
                        .environmentObject(playerData)
                        .environmentObject(stepModel)
                }
                else{
                    WizardView()
                        .environmentObject(playerData)
                        .environmentObject(stepModel)
                }
            }
        }
    }
}
