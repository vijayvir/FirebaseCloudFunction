//
//  MenuController.swift
//  Example
//
//  Created by Teodor Patras on 16/06/16.
//  Copyright © 2016 teodorpatras. All rights reserved.


import UIKit
import Nuke
import SideMenuController


class MenuController: UIViewController   {
    @IBOutlet weak var tableview: UITableView!
     var indexOfLogout = 5
    let segues  = [("showCenterController0" ,#imageLiteral(resourceName: "home") , "Home"),
                   ("showCenterController1" , #imageLiteral(resourceName: "profile") , "Profile"),
                    ("showCenterController2" , #imageLiteral(resourceName: "group") , "Create Group"),
                    ("showCenterController5" , #imageLiteral(resourceName: "search") ,"Search Public Group"),
                    
                     ("showCenterController1" , #imageLiteral(resourceName: "invite") , "Invite"),
                     ("showCenterController1" , #imageLiteral(resourceName: "logout"), "LogOut")] // 4
    
    private var previousIndex: NSIndexPath?
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @objc func updatePic(notification: Notification){
        if (Cookies.userInfo() != nil) {
            let imageURL = URL.init(string: Cookies.userInfo()!.image)
            if imageURL != nil {
                Nuke.loadImage(with: imageURL!, into: userImage)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       //self, selector: #selector(YourClassName.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.updatePic(notification:)), name: Notification.Name("HiveUpdateProfilePic"), object: nil)
        
        userName.text = Cookies.userInfo()?.username
        if (Cookies.userInfo() != nil) {
            let imageURL = URL.init(string: Cookies.userInfo()!.image)
            if imageURL != nil{
                   Nuke.loadImage(with: imageURL!, into: userImage)
            }
         
        }
        
        
        UIApplication.shared.isStatusBarHidden = true
        self.tableview.contentOffset = CGPoint(x: 0, y: 0)
         self.tableview.backgroundColor = .white
    }
    
    @IBAction func cross(_ sender: UIButton) {
        sideMenuController?.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      
        if (Cookies.userInfo() != nil) {
            let imageURL = URL.init(string: Cookies.userInfo()!.image)
            if imageURL != nil {
                Nuke.loadImage(with: imageURL!, into: userImage)
            }
                
            }
           
        
    }
    
}
extension MenuController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segues.count
    }
     func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        cell.textLabel?.text = segues[indexPath.row].2
        cell.imageView?.image = segues[indexPath.row].1
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if indexPath.row == indexOfLogout {
            Alert.showComplex( message: "Are you want to logout", cancelTilte: "Cancel", otherButtons: "Yes") { (i) in
                if i == 0 {
                    Cookies.userInfoSave()
                    UIPhotosButton.removeCache()
                    self.dismiss(animated: false) {
                    }
                }
            }
            return
        }
        if let index = previousIndex {
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        sideMenuController?.performSegue(withIdentifier: segues[indexPath.row].0, sender: nil)
        previousIndex = indexPath as NSIndexPath?
    }
    
    
}
