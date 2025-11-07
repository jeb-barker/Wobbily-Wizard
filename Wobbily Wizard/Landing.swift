//
//  Landing.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/4/25.
//

import SwiftUI

class currUser: ObservableObject{
    @Published var currNickname: String
    @Published var currUUID: UUID
    init(){
        self.currNickname = "Enter Nickname"
        self.currUUID = UUID()
    }
}

struct Landing: View{
    @EnvironmentObject var currUserData: currUser
    @State var seenLanding: Bool = false
    var body: some View{
        NavigationStack{
            VStack{
                Text("Enter a nickname:")
                TextField("Nickname here", text: $currUserData.currNickname)
                //call wizardview() from here, similar to in wizardapp
                //by this point, current user has UUID and nickname
                NavigationLink("Submit", destination: WizardView().environmentObject(currUser()))
            }
        }
    }
}

