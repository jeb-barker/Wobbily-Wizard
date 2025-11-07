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
    @State var seenLanding: Bool = false
    var body: some Scene {
        WindowGroup {
            if(seenLanding == false){
                Landing().environmentObject(currUser())
                    .onAppear(){
                        seenLanding = true
                    }
            }
            else{
                WizardView().environmentObject(currUser())
            }
        }
    }
}
