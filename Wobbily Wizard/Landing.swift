//
//  Landing.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/4/25.
//

import SwiftUI

struct Landing: View{
    @EnvironmentObject var playerData: PlayerData
    @EnvironmentObject var stepModel: StepCountViewModel
    //@State var seenLanding: Bool = false
    var body: some View{
        NavigationStack{
            VStack{
                Text("Enter a nickname:")
                    .font(.title)
                TextField("Nickname here", text: $playerData.currNickname)
                    //.multilineTextAlignment(.center)
                    .padding(10) 
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                //call wizardview() from here, similar to in wizardapp
                //by this point, current user has UUID and nickname
                NavigationLink("Submit", destination: WizardView())
                    .environmentObject(playerData)
                    .environmentObject(stepModel)
            }
        }
    }
}

