
import Foundation
import UIKit
import Firebase

class Conversation {
    
    //MARK: Properties
    let user: User
    var lastMessage: Message
    var isGroup : Bool = false
    
    //MARK: Methods
    class func showConversations( currentUserID : String , completion: @escaping ([Conversation]) -> Swift.Void) {
      //  if let currentUserID = Auth.auth().currentUser?.uid {
            var conversations = [Conversation]()
            Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: Any]
                    let location = values["location"]! as! String
                    if let isGroup = values["isGroup"] as? Bool {
                        
//                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
//                        let user : User = User(name: fromID, email: fromID, id: fromID, profilePic: #imageLiteral(resourceName: "edit_pink"))
//                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
//                        conversation.isGroup = true
//                        conversations.append(conversation)
//                        conversation.lastMessage.downloadLastMessage(currentUserID :currentUserID  , forLocation: location, completion: {
//                              completion(conversations)
//                        })
                        User.info(forUserID: fromID, completion: { (user) in
                            let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true, senderName1: Cookies.userInfo()!.username)
                            let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                            conversation.isGroup = true
                            conversations.append(conversation)
                            conversation.lastMessage.downloadLastMessage(currentUserID :currentUserID  , forLocation: location, completion: {
                                completion(conversations)
                            })
                        })
                        
                        print("Some  group  ")
                    } else {
                        User.info(forUserID: fromID, completion: { (user) in
                            let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true, senderName1:  Cookies.userInfo()!.username)
                            let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                            conversations.append(conversation)
                            conversation.lastMessage.downloadLastMessage(currentUserID :currentUserID  , forLocation: location, completion: {
                            completion(conversations)
                            })
                        })
                    }
                    
                 
                }
            })
        //}
    }
    //MARK: Inits
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
}
