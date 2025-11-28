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
    @State private var fetchedData: [Any]? = nil //for when adding a user
    @State private var fetchUserFriends: [Any]? = nil // for when incrementing relationship on user end
    @State private var fetchFriends: [Any]? = nil //for when incrementing relationship on friend end
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
                //Use for each loop to create a scrollview of users
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
                                            playerData.updateData(field: "sent_potion", value: i["uuid"]!, uuid: playerData.currUUID.uuidString, addFriend: false)
                                            playerData.hasSentPotion = i["uuid"]!
                                            playerData.updateData(field: "recieve_potion", value: playerData.currUUID.uuidString, uuid: i["uuid"]!, addFriend: false)
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
                                            playerData.updateData(field: "recieve_potion", value: "", uuid: playerData.currUUID.uuidString, addFriend: false)
                                            playerData.updateData(field: "sent_potion", value: "", uuid: i["uuid"]!, addFriend: false)
                                            //Increment relationship for both user and friend
                                            Task{
                                                //increment on the user's end
                                                fetchUserFriends = await playerData.fetchDataWithField(field: "UUID", value: playerData.currUUID.uuidString)
                                                if !(fetchUserFriends!.isEmpty){
                                                    var fetchedFriendList = fetchUserFriends![2] as! [[String: Any]]
                                                    for j in 0...fetchedFriendList.count - 1{
                                                        if(j != 0){
                                                            if(fetchedFriendList[j]["friendUUID"]! as! String == i["uuid"]){
                                                                var x = fetchedFriendList[j]["relationship"]! as! Int
                                                                x += 10
                                                                fetchedFriendList[j]["relationship"] = x
                                                            }
                                                        }
                                                    }
                                                    playerData.updateData(field: "friends", value: fetchedFriendList, uuid: playerData.currUUID.uuidString, addFriend: false)
                                                }
                                                //increment on the friend's end
                                                fetchFriends = await playerData.fetchDataWithField(field: "UUID", value: i["uuid"]!)
                                                if !(fetchFriends!.isEmpty){
                                                    var fetchedFriendList = fetchFriends![2] as! [[String: Any]]
                                                    for j in 0...fetchedFriendList.count - 1{
                                                        if(j != 0){
                                                            if(fetchedFriendList[j]["friendUUID"]! as! String == playerData.currUUID.uuidString){
                                                                var x = fetchedFriendList[j]["relationship"]! as! Int
                                                                x += 10
                                                                fetchedFriendList[j]["relationship"] = x
                                                            }
                                                        }
                                                    }
                                                    playerData.updateData(field: "friends", value: fetchedFriendList, uuid: i["uuid"]!, addFriend: false)
                                                    
                                                }
                                            }
                                            
                                        }) {
                                            Label("", systemImage: "tray.and.arrow.down")
                                        }
                                        .offset(x: 120)
                                        .font(.title)
                                        .onAppear(){
                                            Task{
                                                //
                                                let fetchingData = await playerData.fetchDataWithField(field: "UUID", value: playerData.currUUID.uuidString)
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
                //friend search button
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
                                    playerData.updateData(field: "friends", value: ["friendUUID" : friendCode, "friendName": fetchedData![1], "relationship" : 0], uuid: playerData.currUUID.uuidString, addFriend: true)
                                    //Add user to friend's friend list
                                    playerData.updateData(field: "friends", value: ["friendUUID" : playerData.currUUID.uuidString, "friendName": playerData.currNickname, "relationship" : 0], uuid: friendCode, addFriend: true)
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
