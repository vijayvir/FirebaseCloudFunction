//
//  HVPublicGroupListingViewController.swift
//  Hive
//
//  Created by Nitish Sharma on 20/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import UIKit
import IBAnimatable
import Nuke

class HVPublicGroupListingViewController: HVGenricViewController {
    @IBOutlet weak var tableview: UITableView!
    var users : [HiveGroup] = []
    var  filterUser :[HiveGroup] = []
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    func configure(){
        if !isConnectedToInternet(){
            Alert.showSimple("Please connect to internet")
            return
        }
        Hud.show(message: "", view: view)
        WebServices.post(url: .public_group_list, jsonObject: [:], method: .get, completionHandler: { (json) in
            DispatchQueue.main.async { [unowned self] in
                Hud.hide(view: self.view)
                self.users = HiveGroup.grouplistingInComming(json: json)
                self.filterUser = self.users
                self.tableview.reloadData()
                
            }
        }) { (json) in
            
            DispatchQueue.main.async { [unowned self] in
                Hud.hide(view: self.view)
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension  HVPublicGroupListingViewController  : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterUser.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HVGroupLisitingTableViewCell", for: indexPath) as! HVGroupLisitingTableViewCell
        
        let user = filterUser[indexPath.row]
        
        cell.configure(user: user)
        
        cell.closureDidTapOnUser = {
            user in
            
            let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            
            let user = User(name:  user.group_name, email: user.group_name, id: "public\(user.id.leoSafe())", profilePic: #imageLiteral(resourceName: "edit_pink"))
            
            let message = Message(type: .text, content: "Loading", owner: .receiver, timestamp: 0, isRead: false, senderName1:  Cookies.userInfo()!.username)
            
            let conversation = Conversation(user: user, lastMessage: message)
            
            vc.configure(currentUserTemp: "\(Cookies.userInfo()!.id)" , senderUser: user , conversation : conversation)
            
            conversation.isGroup = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
}
extension HVPublicGroupListingViewController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // called when text changes (including clear)
        webserviceSearchBy(text: searchBar.text!)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterUser.removeAll()
        filterUser = users
        tableview.reloadData()
    }
    func webserviceSearchBy(text : String) {
        
        if text.lowercased().count == 0 {
            filterUser.removeAll()
            filterUser = users
            tableview.reloadData()
            return
        }
        filterUser.removeAll()
        filterUser = users.filter({ (user) -> Bool in
            if user.group_name.lowercased().range(of:text.lowercased()) != nil {
                
                return true
            }
            return false
        })
        
        tableview.reloadData()
    }
    
    
}


class HVGroupLisitingTableViewCell : UITableViewCell{
    var user : HiveGroup?
    
    @IBOutlet weak var userimage: AnimatableImageView!
    
    @IBOutlet weak var userName: UILabel!
    var closureDidTapOnUser : ((HiveGroup)->())?
    func configure(user : HiveGroup , searchText : String?  = "") {
        
        self.user = user
        
        userName.text = "\( user.group_name))"
        
        #if targetEnvironment(simulator)
        userName.text = "\( user.group_name) \(user.id.leoSafe())"
        #endif
        
        userimage.image = #imageLiteral(resourceName: "profile pic")
        
//        let imageURL = URL.init(string: user.image.leoSafe() )
//        if imageURL != nil {
//            Nuke.loadImage(with: imageURL!, into: userimage)
//        }else{
//            userimage.image = #imageLiteral(resourceName: "profile pic")
//        }
//
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: (user.group_name))
        if let range =  user.group_name.lowercased().range(of: searchText!.lowercased()) {
            print(range)
            //let rangeNS : NSRange = NSRange(location: range.lowerBound, length: range.)
            //  attrString.addAttribute(.foregroundColor, value:  UIColor.red, range: range as NSRange)
            
            //   addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
            
            userName.attributedText = attrString
        }
        
        
        
        
        
        
        
        
    }
    @IBAction func actionChat(_ sender: UIButton) {
        closureDidTapOnUser?(self.user!)
    }
}

