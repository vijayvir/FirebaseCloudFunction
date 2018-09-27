//
//  HVUserLisitingViewController.swift
//  Hive
//
//  Created by Nitish Sharma on 13/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//
import UIKit
import CoreLocation
import IBAnimatable
import Nuke
class HVUserLisitingViewController: HVGenricViewController{
    @IBOutlet weak var tableview: UITableView!
    var users : [HiveUser] = []
    var  filterUser :[HiveUser] = []
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
        WebServices.post(url: .userListing, jsonObject: [:], method: .get, completionHandler: { (json) in
            DispatchQueue.main.async { [unowned self] in
                Hud.hide(view: self.view)
                self.users = HiveUser.userlistingInComming(json: json)
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
extension  HVUserLisitingViewController  : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return filterUser.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     let cell = tableView.dequeueReusableCell(withIdentifier: "HVUserLisitingTableViewCell", for: indexPath) as! HVUserLisitingTableViewCell
        
        let user = filterUser[indexPath.row]
        
        cell.configure(user: user)
        
        cell.closureDidTapOnUser = {
            user in
            
            let vc  : ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            
            let user = User(name:  user.username, email: user.email, id: "\(user.id.leoSafe())", profilePic: #imageLiteral(resourceName: "edit_pink"))
            
            let message = Message(type: .text, content: "Loading", owner: .receiver, timestamp: 0, isRead: false, senderName1:  Cookies.userInfo()!.username)
            
            let conversation = Conversation(user: user, lastMessage: message)
            
            vc.configure(currentUserTemp: "\(Cookies.userInfo()!.id)" , senderUser: user , conversation : conversation)
            
            conversation.isGroup = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
}
extension HVUserLisitingViewController : UISearchBarDelegate {
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
                if user.username.lowercased().range(of:text.lowercased()) != nil {
        
                    return true
                }
                return false
            })
        
            tableview.reloadData()
    }
    

}
extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

class HVUserLisitingTableViewCell : UITableViewCell{
    var user : HiveUser?
    
    @IBOutlet weak var userimage: AnimatableImageView!
    
    @IBOutlet weak var userName: UILabel!
    var closureDidTapOnUser : ((HiveUser)->())?
    func configure(user : HiveUser , searchText : String?  = "") {
        
        self.user = user
        
        userName.text = "\( user.username))"
        
        #if targetEnvironment(simulator)
        userName.text = "\( user.username) \(user.id.leoSafe())"
        #endif
        
        let imageURL = URL.init(string: user.image.leoSafe() )
        if imageURL != nil {
            Nuke.loadImage(with: imageURL!, into: userimage)
        }else{
            userimage.image = #imageLiteral(resourceName: "profile pic")
        }
        
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: (user.username))
        if let range =  user.username.lowercased().range(of: searchText!.lowercased()) {
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
