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

class seenLanding: ObservableObject{
    @Published var landing: Bool
    init(){
        landing = false
    }
}

@main
struct Wobbily_WizardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var currentUser = currUser()
    @State var hasSeenLanding = seenLanding()
    var body: some Scene {
        WindowGroup {
            if(seenLanding().landing == false){
                Landing()
                    .environmentObject(currentUser)
                    .environmentObject(hasSeenLanding)
            }
            else{
                WizardView()
                    .environmentObject(currentUser)
                    .environmentObject(hasSeenLanding)
            }
        }
    }
}
