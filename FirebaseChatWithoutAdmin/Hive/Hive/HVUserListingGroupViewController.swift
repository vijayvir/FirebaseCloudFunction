//
//  HVUserListingGroupViewController.swift
//  Hive
//
//  Created by Nitish Sharma on 18/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import UIKit
import IBAnimatable
import Nuke
class HVUserListingGroupViewController: HVGenricViewController {
    @IBOutlet weak var tableView: UITableView!
     var users : [HiveUser] = []
    var selectedUser : [HiveUser] = []
    var groupName = ""
    var isPrivate = true
      var currentUserTemp : String  =  "\(Cookies.userInfo()?.id ?? 0)"
    @IBAction func next(_ sender: UIButton) {
        
        print(groupName)
        print(isPrivate)
        print(selectedUser)
        
        if selectedUser.count == 0 {
            Alert.showSimple("Please select one or more member for group.") {
            }
            return
        }
        _ = selectedUser.map({ (user) -> Void in
            print(user.id.leoSafe())
        })
        
        
        let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        Hud.show(message: "Loading", view: self.view)
        let random =  arc4random_uniform( 1000)
        User.registerUser1(userId: "group\(random)", withName: groupName, email: "\(groupName)@Gmail.com", password: "Mind@123", profilePic: #imageLiteral(resourceName: "group")) { (isPass) in
            Hud.hide(view: self.view)
            let user = User(name:  self.groupName, email: "\(self.groupName)@Gmail.com", id: "group\(random)", profilePic: #imageLiteral(resourceName: "group"))
            let message = Message(type: .text, content: "Loading", owner: .receiver, timestamp: 0, isRead: false, senderName1:  Cookies.userInfo()!.username)
            let conversation = Conversation(user: user, lastMessage: message)
            vc.configure(currentUserTemp: self.currentUserTemp, senderUser: user , conversation : conversation)
            conversation.isGroup = true
            vc.selectedUser = self.selectedUser
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
     configure()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure(){
        if !isConnectedToInternet(){
            Alert.showSimple("Please connect to internet")
            return
        }
        Hud.show(message: "", view: view)
        WebServices.post(url: .userListing, jsonObject: [:], method: .get, completionHandler: { (json) in
            DispatchQueue.main.async { [unowned self] in
                Hud.hide(view: self.view)
                self.users = HiveUser.userlistingInComming(json: json)
              
                self.tableView.reloadData()
                
            }
        }) { (json) in
            
            DispatchQueue.main.async { [unowned self] in
                Hud.hide(view: self.view)
            }
            
        }
    }

}

extension  HVUserListingGroupViewController  : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HVUserListingGroupTableViewCell", for: indexPath) as! HVUserListingGroupTableViewCell
        
        let user = users[indexPath.row]
        
        cell.configure(user: user, selectedUsers: selectedUser)
        cell.closureDidTapOnUser = {
            user in
            
            var index = 9999
            for (i ,object ) in self.selectedUser.enumerated() {
                if user.id.leoSafe() == object.id.leoSafe() {
                    
                    index = i
                    break
                }
            }
            
            if index == 9999 {
                self.selectedUser.append(user)
            }else {
                 self.selectedUser.remove(at: index)
            }
           
            self.tableView.reloadData()
            
        }
        return cell
    }
}

class  HVUserListingGroupTableViewCell  : UITableViewCell{
        var user : HiveUser?
    @IBOutlet weak var userNAme: UILabel!
    @IBOutlet weak var imageV: AnimatableImageView!
     var closureDidTapOnUser : ((HiveUser)->())?
    @IBOutlet weak var imgIsSelected: UIImageView!
    func configure(user : HiveUser , selectedUsers : [HiveUser]){
        self.user = user
        imgIsSelected.isHidden = true
        
        for user1 in selectedUsers {
            if user1.id.leoSafe() ==  user.id.leoSafe(){
                imgIsSelected.isHidden = false
                break
            }
            
        }
        userNAme.text = "\( user.username))"
        
        #if targetEnvironment(simulator)
        userNAme.text = "\( user.username) \(user.id.leoSafe())"
        #endif
        
        let imageURL = URL.init(string: user.image.leoSafe() )
        if imageURL != nil {
            Nuke.loadImage(with: imageURL!, into: imageV)
        }else{
            imageV.image = #imageLiteral(resourceName: "profile pic")
        }
        
    }
    
    @IBAction func actionSelect(_ sender: UIButton) {
        
    closureDidTapOnUser?(user!)
    }
    
}
