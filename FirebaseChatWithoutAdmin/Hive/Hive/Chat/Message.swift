
import Foundation
import UIKit
import Firebase

enum ChatType {
    case  oneOne
    case  privateGroup
    case publicGroup
}

class Message {
    //MARK: Properties
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var image: UIImage?
    private var toID: String?
    private var fromID: String?
    var senderName : String?
    //MARK: Methods
    
    class func downloadAllMessages(currentUserTemp : String ,  toID: String, completion: @escaping (Message) -> Swift.Void) {
            Database.database().reference().child("users").child(currentUserTemp).child("conversations").child(toID)
                .queryLimited(toFirst: 10)
                .observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    let data = snapshot.value as! [String: Any]
                    let location = data["location"]! as!String
                    Database.database().reference().child("conversations").child(location).observe(.childAdded, with: { (snap) in
                        if snap.exists() {
                            let receivedMessage = snap.value as! [String: Any]
                            let messageType = receivedMessage["type"] as! String
                            var type = MessageType.text
                            switch messageType {
                                case "photo":
                                type = .photo
                                case "location":
                                type = .location
                            default: break
                            }
                            let content = receivedMessage["content"] as! String
                            let fromID = receivedMessage["fromID"] as! String
                            let timestamp = receivedMessage["timestamp"] as! Int
                            let senderName =  receivedMessage["senderName"] as? String ?? "unknown"
                            
                            if fromID == currentUserTemp {
                                let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: true, senderName1: senderName)
                                completion(message)
                            } else {
                                let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true, senderName1: senderName)
                                completion(message)
                            }
                        }
                    })
                }
            })
        
    }
    
    func downloadImage(indexpathRow: Int, completion: @escaping (Bool, Int) -> Swift.Void)  {
        if self.type == .photo {
            let imageLink = self.content as! String
            let imageURL = URL.init(string: imageLink)
            URLSession.shared.dataTask(with: imageURL!, completionHandler: { (data, response, error) in
                if error == nil {
                    self.image = UIImage.init(data: data!)
                    completion(true, indexpathRow)
                }
            }).resume()
        }
    }
    
    class func markMessagesRead(forUserID: String)  {
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.exists() {
//                    let data = snapshot.value as! [String: String]
//                    let location = data["location"]!
//                    Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
//                        if snap.exists() {
//                            for item in snap.children {
//                                let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
//                                let fromID = receivedMessage["fromID"] as! String
//                                if fromID != currentUserID {
//                                    Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
//                                }
//                            }
//                        }
//                    })
//                }
//            })
//        }
    }
//
    
//
//    content:
//    "Helllo first message "
//    fromID:
//    "user1"
//    isRead:
//    false
//    timestamp:
//    1536208539
//    toID:
//    "user2"
//    type:
//    "text"

    func downloadLastMessage(currentUserID : String , forLocation: String, completion: @escaping () -> Swift.Void) {
        //if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("conversations").child(forLocation).observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    for snap in snapshot.children {
                        if let receivedMessage = (snap as! DataSnapshot).value as? [String: Any]  {
                            self.content = receivedMessage["content"]!
                            self.timestamp = receivedMessage["timestamp"] as! Int
                            let messageType = receivedMessage["type"] as! String
                            let fromID = receivedMessage["fromID"] as! String
                            self.isRead = receivedMessage["isRead"] as! Bool
                            var type = MessageType.text
                            switch messageType {
                            case "text":
                                type = .text
                            case "photo":
                                type = .photo
                            case "location":
                                type = .location
                            default: break
                            }
                            self.type = type
                            if currentUserID == fromID {
                                self.owner = .receiver
                            } else {
                                self.owner = .sender
                            }
                        }
                   
                        completion()
                    }
                }
            })
     //   }
    }
    class func send(message: Message, toID: String, currentUserID : String  , isGroup : Bool = false , chatType : ChatType? = .oneOne , users : [HiveUser] = [], completion: @escaping (Bool) -> Swift.Void)  {
        switch message.type {
        case .location:
            let values = ["type": "location", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
//            Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
//                completion(status)
//            })
        case .photo:
            let imageData = UIImageJPEGRepresentation((message.content as! UIImage), 0.5)
            let child = UUID().uuidString
//            Storage.storage().reference().child("messagePics").child(child).putData(imageData!, metadata: nil, completion: { (metadata, error) in
//                if error == nil {
//                    let path = metadata?.downloadURL()?.absoluteString
//                    let values = ["type": "photo", "content": path!, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false] as [String : Any]
//                    Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
//                        completion(status)
//                    })
//                }
//            })
        case .text:
            var values = ["type": "text",
                          "content": message.content,
                          "fromID": currentUserID,
                          "toID": toID,
                          "timestamp": message.timestamp,
                          "isRead": false]
            
              values["senderName"] = Cookies.userInfo()!.username
            
            if isGroup {
                values["isGroupChat"] = true
                
                if chatType == .publicGroup {
                    
                    
                    Message.uploadMessagePublicChat(withValues: values, toID: toID,currentUserID :currentUserID , completion: { (status) in
                        completion(status)
                    })
                }else {
                    Message.uploadMessageToGroup(withValues: values, toID: toID,currentUserID :currentUserID , users : users , completion: { (status) in
                        completion(status) })
                    
                }
            }else {
                  values["isGroupChat"] = false
                Message.uploadMessage(withValues: values, toID: toID,currentUserID :currentUserID , completion: { (status) in
                    completion(status)
                })
            }
          
        }
    }

    class func uploadMessageToGroup(withValues: [String: Any], toID: String , currentUserID : String , users : [HiveUser] = [] , completion: @escaping (Bool) -> Swift.Void) {
        
        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as! [String: Any]
                let location = data["location"]! as! String
                Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                // Here add the location to user
                Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                    let data = ["location": reference.parent!.key ,"isGroup": true   ] as [String : Any]
                   // group
                    Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
                    
                    Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
                    for user in users {
                    Database.database().reference().child("users").child("\(user.id.leoSafe())").child("conversations").child(toID).updateChildValues(data)
                    }
                    completion(true)
                })
            }
        })
    }
    
    
    class func uploadMessagePublicChat(withValues: [String: Any], toID: String , currentUserID : String , completion: @escaping (Bool) -> Swift.Void) {
        
        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as! [String: Any]
                let location = data["location"]! as! String
                Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                Database.database().reference().child("conversations").child(toID).childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                    let data = ["location": reference.parent!.key,"isGroup": true   ] as [String : Any]
                    Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
                    Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
                    completion(true)
                })
            }
        })
    }
    
    
    
    
    class func uploadMessage(withValues: [String: Any], toID: String , currentUserID : String , completion: @escaping (Bool) -> Swift.Void) {
        
        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as! [String: Any]
                let location = data["location"]! as! String
                Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                    let data = ["location": reference.parent!.key]
                    Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
                    Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
                    completion(true)
                })
            }
        })
    }
    
    //MARK: Inits
    init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool , senderName1 : String) {
        self.type = type
        self.content = content
        self.owner = owner
        self.timestamp = timestamp
        self.isRead = isRead
        self.senderName = senderName1
    }
}
