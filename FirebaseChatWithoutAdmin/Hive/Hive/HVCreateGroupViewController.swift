//
//  HVCreateGroupViewController.swift
//  Hive
//
//  Created by Nitish Sharma on 10/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import UIKit
class HVCreateGroupViewController: HVGenricViewController {
    @IBOutlet weak var btnPrivate: UIButton!
    @IBOutlet weak var btnGroup: UIButton!
    @IBOutlet weak var textField: UITextField!
    var currentUserTemp : String  =  "\(Cookies.userInfo()?.id ?? 0)"
    override func viewDidLoad() {
        super.viewDidLoad()
       btnGroup.isSelected = false
       btnPrivate.isSelected = true
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionNext(_ sender: UIButton) {
        
        if textField.text!.count <= 0 {
            Alert.showSimple("Please enter Group Name.") {
            }
            return
        }

        let vc  : HVUserListingGroupViewController = self.storyboard?.instantiateViewController(withIdentifier: "HVUserListingGroupViewController") as! HVUserListingGroupViewController
        vc.groupName = textField.text.leoSafe()
        vc.isPrivate = true
        if btnPrivate.isSelected {
             apiCreatePublicGroup()
            print(textField.text.leoSafe())
        } else {
                vc.isPrivate = true
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func apiCreatePublicGroup(){
        if !isConnectedToInternet(){
            Alert.showSimple("Please connect to internet")
            return
        }
        Hud.show(message: "", view: view)
        var request : [String:Any] = [:]
          request["user_id"] =  Cookies.userInfo()!.id
          request["group_name"] = textField.text.leoSafe()
        WebServices.post(url: .userPublicGroup, jsonObject: request, completionHandler: { (json) in
            Hud.hide(view: self.view)
            if isSuccess(json: json){
                if let body = json["body"] as? NSArray {
                    if let dict = body.firstObject as? [String : Any]{
                
                        print(dict["id"]!)
                        
                        let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                        
                        let random = dict["id"]!
                        
                        User.registerUser1(userId: "public\(random)", withName: self.textField.text.leoSafe(), email: "group\(random)@Gmail.com", password: "Mind@123", profilePic: #imageLiteral(resourceName: "location")) { (isPass) in
                            
                            let user = User(name:  self.textField.text.leoSafe(), email: "public\(random)@Gmail.com", id: "public\(random)", profilePic: #imageLiteral(resourceName: "group"))
                            let message = Message(type: .text, content: "Loading", owner: .receiver, timestamp: 0, isRead: false, senderName1:  Cookies.userInfo()!.username)
                            let conversation = Conversation(user: user, lastMessage: message)
                            vc.configure(currentUserTemp: self.currentUserTemp, senderUser: user , conversation : conversation)
                            conversation.isGroup = true
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                        
                        
                    }
                }
                // "body": <__NSSingleObjectArrayI 0x604000010660>(
//                {
//                    "created_at" = "2018-09-20T08:03:02.000Z";
//                    "group_name" = "I don\U2019t want d";
//                    id = 2;
//                    status = 0;
//                    "user_id" = 42;
//                }
                
                print(json)
            }else {
                Alert.showSimple("Something wrong happens.")
            }
        },failureHandler: { (json) in
            Hud.hide(view: self.view)
        })

    }
    
    @IBAction func actionPrivate(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
                   btnGroup.isSelected = false
        }else {
              btnGroup.isSelected = true
        }
        return
        
        
        let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
      
        let random =  arc4random_uniform( 1000)
        
        User.registerUser(userId: "group\(random)", withName: "group\(random)", email: "group\(random)@Gmail.com", password: "Mind@123", profilePic: #imageLiteral(resourceName: "location")) { (isPass) in

            let user = User(name:  "group\(random)", email: "group\(random)@Gmail.com", id: "group\(random)", profilePic: #imageLiteral(resourceName: "group"))
            let message = Message(type: .text, content: "Loading", owner: .receiver, timestamp: 0, isRead: false, senderName1:  Cookies.userInfo()!.username)
            let conversation = Conversation(user: user, lastMessage: message)
            vc.configure(currentUserTemp: self.currentUserTemp, senderUser: user , conversation : conversation)
            conversation.isGroup = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

    
        

    }
    
    @IBAction func actionPublic(_ sender: UIButton) {
        
        
            sender.isSelected = !sender.isSelected
       
        if sender.isSelected {
            btnPrivate.isSelected = false
        }else {
            btnPrivate.isSelected = true
        }
        
        return
        
        let random =  arc4random_uniform( 1000)
        let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        
        
        User.registerUser(userId: "user\(random)", withName: "user\(random)", email: "user\(random)@Gmail.com", password: "Mind@123", profilePic: #imageLiteral(resourceName: "edit_pink")) { (isPass) in
            let user = User(name:  "user\(random)", email: "user\(random)@Gmail.com", id: "user\(random)", profilePic: #imageLiteral(resourceName: "edit_pink"))
            let message = Message(type: .text, content: "Loading", owner: .receiver, timestamp: 0, isRead: false, senderName1:  Cookies.userInfo()!.username)
            let conversation = Conversation(user: user, lastMessage: message)
            vc.configure(currentUserTemp: self.currentUserTemp, senderUser: user , conversation : conversation)
            conversation.isGroup = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

        
        
    }
}
