//
//  PlayerData.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 11/8/25.
//
import Combine
import SwiftUI
import Firebase
import FirebaseFirestore

// Observable object with the data for the player
class PlayerData: ObservableObject, Codable {
    // Each item in inventory: [item, amount]
    @Published var inventory: [InventoryItem] = []
    // Each potion in list: [type, amount]
    @Published var potions: [InventoryPotion] = []
    @Published var balance: Int = 0
    @Published var hasSeenLanding: Bool = false
    @Published var currUUID: UUID = UUID()
    @Published var currNickname: String = ""
    //array of dictionaries for friends
    @Published var friendsList: [[String: Any]] = [["  ": " "]]
    /* TEST DUMMY DATA TO TEST IF FIREBASE WOULD CONVERT ARRAY OF DICTS TO MAP ARRAY OF MAP TYPES
    @Published var friendsListDUMMY: [[String : Any]] = [
        ["friend" : "1234567890", "isSendingPotion" : false, "relationship": 0],
        ["friend" : "4567890123", "isSendingPotion" : false,"relationship" : 10]
    ]
     */
    //String of UUID of the person its sent to
    @Published var hasRecievedPotion: String = ""
    //String of UUID of the person its sent to
    @Published var hasSentPotion: String = ""
    @Published var documentId: String = ""
    @Published var hasFriendPotion : Bool = false
    

    enum CodingKeys: String, CodingKey {
        case inventory, potions, balance, hasSeenLanding, currUUID, currNickname
    }

    // Try and load saved data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        inventory = try container.decode([InventoryItem].self, forKey: .inventory)
        potions = try container.decode([InventoryPotion].self, forKey: .potions)
        balance = try container.decode(Int.self, forKey: .balance)
        hasSeenLanding = try container.decode(Bool.self, forKey: .hasSeenLanding)
        currUUID = try container.decode(UUID.self, forKey: .currUUID)
        currNickname = try container.decode(String.self, forKey: .currNickname)
    }

    // Encode data to be saved
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inventory, forKey: .inventory)
        try container.encode(potions, forKey: .potions)
        try container.encode(balance, forKey: .balance)
        try container.encode(hasSeenLanding, forKey: .hasSeenLanding)
        try container.encode(currUUID, forKey: .currUUID)
        try container.encode(currNickname, forKey: .currNickname)
    }
    
    private var db = Firestore.firestore()
    
    // remove item from the inventory
    func decreaseItem(_ name: String) {
        if let index = inventory.firstIndex(where: { $0.name == name }) {
            if inventory[index].amount > 0 {
                inventory[index].amount -= 1
                save()   // optional but recommended so it persists
            }
        }
    }
    // add item to inventory
    func addItem(_ name: String) {
        if let index = inventory.firstIndex(where: { $0.name == name }) {
            inventory[index].amount += 1
            save()   // keep data persistent
        }
    }
    //add user to firebase
    
    func addUser(){
        do{
            let _ = try db.collection("users").addDocument(data:[
                "UUID" : currUUID.uuidString,
                "nickname" : currNickname,
                "friends" : friendsList,
                "recieve_potion" : hasRecievedPotion,
                "sent_potion" : hasSentPotion,
            ])
        }
        catch{
            print("error")
        }
    }
    
    func fetchDataWithField(field: String, value: String) async -> [Any] {
        var arr: [Any] = []
        do {
            let result = try await db.collection("users")
                    .whereField(field, isEqualTo: value)
                    .getDocuments()
            
            for document in result.documents {
                print("\(document.documentID) => \(document.data())")
                print(document.data()["UUID"]! as! String)
                arr.append(document.data()["UUID"]! as! String)
                arr.append(document.data()["nickname"]! as! String)
                arr.append(document.data()["friends"]! as! [[String:Any]])
                arr.append(document.data()["recieve_potion"]! as! String)
                arr.append(document.data()["sent_potion"]! as! String)
            }
            return arr
        } catch {
            print("error")
        }
        
        return []
    }
    
    func updateData(field: String, value: Any, uuid: String, addFriend: Bool) {
        let users = self.db.collection("users") //self.db points to *my* firestore
            users.whereField("UUID", isEqualTo: uuid).limit(to: 1).getDocuments(completion: { querySnapshot, error in
                if let err = error {
                    print("error")
                    return
                }

                guard let docs = querySnapshot?.documents else { return }

                for doc in docs {
                    let ref = doc.reference
                    if(field == "friends" && addFriend == true){
                        ref.updateData([
                            field : FieldValue.arrayUnion([value])
                        ])
                    }
                    else{
                        ref.updateData([field: value])
                    }
                }
            })
    
    }

    // Load data from file or create defaults
    init() {
        if let saved = PlayerData.load() {
            self.inventory = saved.inventory
            self.potions = saved.potions
            self.balance = saved.balance
            self.hasSeenLanding = saved.hasSeenLanding
            self.currUUID = saved.currUUID
            self.currNickname = saved.currNickname
        } else {
            // Default data: Player starts with 500 gems, enough ingredients to make 3 fire potions, and has 2 ice potions
            self.inventory = [
                InventoryItem("Sunflower", 3), InventoryItem("Hot Pepper", 3), InventoryItem("Thermometer", 3), InventoryItem("Fire Cracker", 3), InventoryItem("Cable", 0), InventoryItem("Battery", 0), InventoryItem("Lightning", 0), InventoryItem("Device", 0), InventoryItem("Snake", 0), InventoryItem("Vial", 0), InventoryItem("Skull", 0), InventoryItem("Nuclear Waste", 0), InventoryItem("Ice Cube", 0), InventoryItem("Ice Cream", 0), InventoryItem("Frozen Fred", 0), InventoryItem("Penguin", 0)
            ]
            self.potions = [InventoryPotion("fire", 1), InventoryPotion("electric", 1), InventoryPotion("poison", 1), InventoryPotion("ice", 1)]
            self.balance = 500
        }
    }
    

    // Path for saving data to device
    static private var saveURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("playerData.json")
    }

    // Saving and loading the file
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            try? encoded.write(to: Self.saveURL)
        }
    }

    // Load from device if possible
    static func load() -> PlayerData? {
        guard let data = try? Data(contentsOf: saveURL) else { return nil }
        return try? JSONDecoder().decode(PlayerData.self, from: data)
    }
    
    //pretty print
    func printPretty() {
        for item in inventory {
            if item.amount > 0 {
                print("\(item.amount) \(item.name)")
            }
        }
    }

}
