//
//  Social.swift
//  Wobbily Wizard
//
//  Created by user287117 on 10/28/25.
//

import SwiftUI

struct Friends: View{
    @EnvironmentObject var currUserData : currUser
    var body: some View{
        //hardcoded array of UIDs, ideally backend would exist to store usernames and UIDs
        let userID = UUID()
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let id4 = UUID()
        let id5 = UUID()
        let id6 = UUID()
        let id7 = UUID()
        let arr = [id1, id2, id3, id4, id5, id6, id7]
        VStack{
            Text("Friends List")
                .bold()
                .font(.title2)
            Text(currUserData.currNickname)
            Text(currUserData.currUUID.uuidString)
                .textSelection(.enabled)
            let lightBlue = Color(red: 0, green: 50, blue: 186)
            ScrollView{
                ForEach(arr, id: \.self){ userId in
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(lightBlue)
                            .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight * 0.13, alignment: .center)
                        VStack{
                            Text("Nickname")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding()
                            Text(userId.uuidString)
                                .font(.caption)
                                .textSelection(.enabled)
                        }
                    }
                }
                    
            }
        }
        
    }
}
