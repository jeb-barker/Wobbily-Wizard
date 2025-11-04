import SwiftUI

class currUser: ObservableObject{
    @Published var currNickname: String
    @Published var currUUID: UUID
    init(){
        self.currNickname = "nickname"
        self.currUUID = UUID()
    }
}

struct Landing: View{
    @EnvironmentObject var currUserData: currUser
    var body: some View{
        VStack{
            Text("Enter a nickname:")
            TextField("Nickname here", text: $currUserData.currNickname)
            //by this point, current user has UUID and nickname
        }
    }
}

