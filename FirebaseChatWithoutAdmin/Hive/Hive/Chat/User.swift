//  MIT License

//  Copyright (c) 2017 Haik Aslanyan

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation
import UIKit
import Firebase
import FirebaseStorage
import Nuke
class User: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    //MARK: Methods
    
    
    class func markMessagesRead(forUserID: String)  {
                if let currentUserID = Auth.auth().currentUser?.uid {
                    Database.database().reference().child("users").child(currentUserID).child("conversations").child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists() {
                            let data = snapshot.value as! [String: String]
                            let location = data["location"]!
                            Database.database().reference().child("conversations").child(location).observeSingleEvent(of: .value, with: { (snap) in
                                if snap.exists() {
                                    for item in snap.children {
                                        let receivedMessage = (item as! DataSnapshot).value as! [String: Any]
                                        let fromID = receivedMessage["fromID"] as! String
                                        if fromID != currentUserID {
                                            Database.database().reference().child("conversations").child(location).child((item as! DataSnapshot).key).child("isRead").setValue(true)
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
    }
    
    
    class func addTokenInGroupChatWithID(meID: String ,groupName: String , token : String )  {
        let tokens = [meID:token]
        Database.database().reference().child("users").child(groupName).child("tokens").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
            Database.database().reference().child("users").child(groupName).child("tokens").child(meID).setValue(token)
            } else {
            Database.database().reference().child("users").child(groupName).child("tokens").child(meID).setValue(token)
            }
        })
        
    }
    
    
    
    
    class func updateDeviceToken(forUserID: String , token : String)  {
 Database.database().reference().child("users").child(forUserID).child("credentials").child("token").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
         Database.database().reference().child("users").child(forUserID).child("credentials").child("token").setValue(token)

            } else {
                print(snapshot)
        Database.database().reference().child("users").child(forUserID).child("credentials").child("token").setValue(token)
                
            }
        })
     
    }
    
    
    
    class func updateProfilePicLink(forUserID: String , imageURl : String)  {
        
        // profilePicLink
        
       // if let currentUserID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(forUserID).child("credentials").child("profilePicLink").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                 
                    Database.database().reference().child("users").child(forUserID).child("credentials").child("profilePicLink").setValue(imageURl)
                
                    
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
                }
            })
       // }
    }
    class func registerUser1( userId : String,withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        
        let values = ["name": withName,
                      "email": email,
                      "profilePicLink": "http://hive.techangouts.com/uploads/grpchat.jpeg" ,
            "properPath" : "http://hive.techangouts.com/uploads/grpchat.jpeg" ]
        
        Database.database().reference().child("users").child(userId).child("credentials").updateChildValues(values , withCompletionBlock: { (errr, _) in
            if errr == nil {
                let userInfo = ["email" : email, "password" : password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                print(errr)
            }
        })
        
        
        return ;
        
        
        
        
        // http://hive.techangouts.com/uploads/grpchat.jpeg
        let storageRef = Storage.storage().reference().child("usersProfilePics").child(userId)
        
        let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
        storageRef.putData(imageData!, metadata: nil, completion: { (metadata1, err) in
            if err == nil {
                let path = metadata1?.path
                //let pathReference = storage.reference(withPath: "images/stars.jpg")
                let pathReference = Storage.storage().reference(withPath: path!)
                
                pathReference.downloadURL(completion: { (urls, errr) in
                    print("*********" , urls ?? "NG")
                    let values = ["name": withName,
                                  "email": email,
                                  "profilePicLink": "\(String(describing: urls!))" ,
                        "properPath" : "\(String(describing: urls!))" ]
                    
                    Database.database().reference().child("users").child(userId).child("credentials").updateChildValues(values ?? [:], withCompletionBlock: { (errr, _) in
                        if errr == nil {
                            let userInfo = ["email" : email, "password" : password]
                            UserDefaults.standard.set(userInfo, forKey: "userInformation")
                            completion(true)
                        } else {
                            print(errr)
                        }
                    })
                })
                
                // let path1 = metadata1?.storageReference?.bucket
                
                
            } else {
                print(err.debugDescription)
                completion(false)
            }
        })
    }
    
    
    
    
    class func registerPublicGroup( userId : String,withName: String, email: String, completion: @escaping (Bool) -> Swift.Void) {
        //
        
        // Pooja [4:58 PM]
        //  http://hive.techangouts.com/uploads/default.jpeg
        
        let values = ["name": withName,
                      "email": email,
                      "profilePicLink": "http://hive.techangouts.com/uploads/default.jpeg" ,
                      "properPath" : "http://hive.techangouts.com/uploads/default.jpeg" ]
        
        Database.database().reference().child("users").child(userId).child("credentials").updateChildValues(values , withCompletionBlock: { (errr, _) in
            if errr == nil {
          
                completion(true)
            } else {
                print(errr)
            }
        })
    }
    
    class func registerUser( userId : String,withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        //
        
        // Pooja [4:58 PM]
      //  http://hive.techangouts.com/uploads/default.jpeg
        
        let values = ["name": withName,
                      "email": email,
                      "profilePicLink": "http://hive.techangouts.com/uploads/default.jpeg" ,
            "properPath" : "http://hive.techangouts.com/uploads/default.jpeg" ]
        
        Database.database().reference().child("users").child(userId).child("credentials").updateChildValues(values , withCompletionBlock: { (errr, _) in
            if errr == nil {
                let userInfo = ["email" : email, "password" : password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                print(errr)
            }
        })
        
        return
        
        
                let storageRef = Storage.storage().reference().child("usersProfilePics").child(userId)
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata1, err) in
                    if err == nil {
                          let path = metadata1?.path
                        //let pathReference = storage.reference(withPath: "images/stars.jpg")
                        let pathReference = Storage.storage().reference(withPath: path!)

                        pathReference.downloadURL(completion: { (urls, errr) in
                            
                            print("*********" , urls ?? "NG")
                            let values = ["name": withName,
                                          "email": email,
                                          "profilePicLink": "\(String(describing: urls!))" ,
                                "properPath" : "\(String(describing: urls!))" ]
                            
                            Database.database().reference().child("users").child(userId).child("credentials").updateChildValues(values , withCompletionBlock: { (errr, _) in
                                if errr == nil {
                                    let userInfo = ["email" : email, "password" : password]
                                    UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                    completion(true)
                                } else {
                                    print(errr)
                                }
                            })
                        })
                        
                       // let path1 = metadata1?.storageReference?.bucket
                        
                      
                    } else {
                        print(err.debugDescription)
                         completion(false)
                    }
                })
    }
//
//   class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
//        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
//            if error == nil {
//                let userInfo = ["email": withEmail, "password": password]
//                UserDefaults.standard.set(userInfo, forKey: "userInformation")
//                completion(true)
//            } else {
//                completion(false)
//            }
//        })
//    }
//    
//    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
//        do {
//            try Auth.auth().signOut()
//            UserDefaults.standard.removeObject(forKey: "userInformation")
//            completion(true)
//        } catch _ {
//            completion(false)
//        }
//    }
//    
   class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let link = URL.init(string: data["profilePicLink"]!)
              
                
//                let user = User.init(name: name, email: email, id: forUserID, profilePic: #imageLiteral(resourceName: "location"))
//                completion(user)
                
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
//
//    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
//        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
//            let id = snapshot.key
//            let data = snapshot.value as! [String: Any]
//            let credentials = data["credentials"] as! [String: String]
//            if id != exceptID {
//                let name = credentials["name"]!
//                let email = credentials["email"]!
//                let link = URL.init(string: credentials["profilePicLink"]!)
//                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
//                    if error == nil {
//                        let profilePic = UIImage.init(data: data!)
//                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!)
//                        completion(user)
//                    }
//                }).resume()
//            }
//        })
//    }
//    
//    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
//        Auth.auth().currentUser?.reload(completion: { (_) in
//            let status = (Auth.auth().currentUser?.isEmailVerified)!
//            completion(status)
//        })
//    }

    
    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
}

