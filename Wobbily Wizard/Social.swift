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
        ZStack{
            Image("home_background").resizable().scaledToFill().ignoresSafeArea()
            VStack{
                Text("Friends List")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                Text(playerData.currNickname)
                    .foregroundColor(.white)
                Text(playerData.currUUID.uuidString)
                    .foregroundColor(.white)
                //Text(playerData.documentId)
                    .textSelection(.enabled)
                ScrollView{
                    ForEach(listOfFriends.dropFirst(), id: \.self){ i in
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.indigo)
                                .frame(width: UIScreen.screenWidth * 0.85, height: UIScreen.screenHeight * 0.13, alignment: .center)
                            VStack{
                                ZStack{
                                    Image("friendIcon")
                                        .offset(x: -120)
                                    Text(i["nickname"]!)
                                        .padding(.leading, 10)
                                        .font(.largeTitle)
                                        .fontWeight(.semibold)
                                    VStack{
                                        //Send Potion
                                        Button(action: {
                                            print("potion sent!")
                                            playerData.updateData(field: "sent_potion", value: i["uuid"]!, uuid: playerData.currUUID.uuidString)
                                            playerData.hasSentPotion = i["uuid"]!
                                            playerData.updateData(field: "recieve_potion", value: playerData.currUUID.uuidString, uuid: i["uuid"]!)
                                        }) {
                                            Label("", systemImage: "paperplane")
                                        }
                                        .offset(x: 120)
                                        .font(.title)
                                        .disabled(!(playerData.hasSentPotion.isEmpty))
                                        
                                        //Claim Potion
                                        Button(action: {
                                            print("potion recieved!")
                                            //At this point, hasRecievedPotion has the UUID of the friend who sent a potion
                                            //INCREMENT FRIEND POTION HERE !!!!!!!!!!!!!!!!
                                            playerData.hasRecievedPotion = ""
                                            playerData.updateData(field: "recieve_potion", value: "", uuid: playerData.currUUID.uuidString)
                                            playerData.updateData(field: "sent_potion", value: "", uuid: i["uuid"]!)
                                            //INCREMENT RELATIONSHIP HERE
                                            
                                        }) {
                                            Label("", systemImage: "tray.and.arrow.down")
                                        }
                                        .offset(x: 120)
                                        .font(.title)
                                        .onAppear(){
                                            Task{
                                                var fetchingData = await playerData.fetchDataWithField(field: "UUID", value: playerData.currUUID.uuidString)
                                                playerData.hasRecievedPotion = fetchingData[3] as! String
                                            }
                                        }
                                        //disable button if hasRecievedPotion is empty and if one friend sent you a potion
                                        .disabled(playerData.hasRecievedPotion.isEmpty || playerData.hasRecievedPotion != i["uuid"])
                                    }
                                        
                                }
                                Text(i["uuid"]!)
                                    .font(.caption)
                                    .textSelection(.enabled)
                            }
                        }
                    }
                    
                }

                HStack{
                    TextField("Enter UUID here", text: $friendCode)
                        .foregroundColor(.white)
                        .frame(width: 300)
                        .padding(10)
                        .background(Color.black.opacity(0.1))
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
                                //prevent repeat friends / adding yourself
                                var preventAppend = false
                                for i in listOfFriends {
                                    if i["uuid"] == temp["uuid"] || temp["uuid"] == playerData.currUUID.uuidString {
                                        preventAppend = true
                                    }
                                }
                                if (preventAppend == false){
                                    listOfFriends.append(temp)
                                    //Add friend to user's friend list
                                    playerData.updateData(field: "friends", value: ["friendUUID" : friendCode, "friendName": fetchedData![1], "isSendingPotion" : false, "relationship" : 0], uuid: playerData.currUUID.uuidString)
                                    //Add user to friend's friend list
                                    playerData.updateData(field: "friends", value: ["friendUUID" : playerData.currUUID.uuidString, "friendName": playerData.currNickname, "isSendingPotion" : false, "relationship" : 0], uuid: friendCode)
                                    friendCode = ""
                                }
                                
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                }
                
            }
        }
        
    }
}
