//
//  Social.swift
//  Wobbily Wizard
//
//  Created by user287117 on 10/28/25.
//

import SwiftUI

struct Friends: View{
    @EnvironmentObject var playerData: PlayerData
    @State private var friendCode: String = ""
    @State private var fetchedData: [Any]? = nil
    //Dict representing friendNickname: friendUUID
    @State private var listOfFriends: [[String: String]] = [["nickname" : " ", "uuid" : " "]]
    var body: some View{
        //hardcoded array of UIDs, ideally backend would exist to store usernames and UIDs
        VStack{
            Text("Friends List")
                .bold()
                .font(.title2)
            Text(playerData.currNickname)
            Text(playerData.currUUID.uuidString)
            //Text(playerData.documentId)
                .textSelection(.enabled)
            let lightBlue = Color(red: 0, green: 50, blue: 186)
            ScrollView{
                ForEach(listOfFriends.dropFirst(), id: \.self){ i in
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .fill(lightBlue)
                            .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight * 0.13, alignment: .center)
                        VStack{
                            Text(i["nickname"]!)
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding()
                            Text(i["uuid"]!)
                                .font(.caption)
                                .textSelection(.enabled)
                        }
                    }
                }
                    
            }
            HStack{
                TextField("Enter UUID here", text: $friendCode)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Button("Add"){
                    print("Added!")
                    Task {
                        //used for getting friend nickname
                        fetchedData = await playerData.fetchDataWithField(field: "UUID", value: friendCode)
                        //add friend data to friends dict in currUser firebase. only defaults are needed here since this is a brand new friend, so of course you have no relationship with them nor have they sent you anything
                        //if fetchedData is a uuid that appears in firebase
                        if !(fetchedData!.isEmpty){
                            let friendUUID = fetchedData![0] as! String
                            let friendNickname = fetchedData![1] as! String
                            let temp = (["uuid" : friendUUID, "nickname" : friendNickname])
                            //prevent repeat friends
                            var preventAppend = false
                            for i in listOfFriends {
                                if i["uuid"] == temp["uuid"] || temp["uuid"] == playerData.currUUID.uuidString {
                                    preventAppend = true
                                }
                            }
                            if (preventAppend == false){
                                listOfFriends.append(temp)
                            }
                            playerData.updateData(field: "friends", value: ["friendUUID" : friendCode, "friendName": fetchedData![1], "isSendingPotion" : false, "relationship" : 0], uuid: playerData.currUUID.uuidString)
                        }
                    }
                    

                }
            }
            
        }
        
    }
}
