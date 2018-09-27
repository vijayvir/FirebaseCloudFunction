//
//  HVProfileViewController.swift
//  Hive
//
//  Created by Nitish Sharma on 05/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import UIKit
import Nuke
class HVProfileViewController: HVGenricViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var communication: UILabel!
    @IBOutlet weak var linkedIn: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if (Cookies.userInfo() != nil) {
            let imageURL = URL.init(string: Cookies.userInfo()!.image)
            if imageURL != nil{
                Nuke.loadImage(with: imageURL!, into: userImage)
            }
        }
         username.text = Cookies.userInfo()?.username
         location.text = Cookies.userInfo()?.location
         phone.text = Cookies.userInfo()?.contact
         communication.text = Cookies.userInfo()?.key_skills
         linkedIn.text = Cookies.userInfo()?.linkedin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        username.text = Cookies.userInfo()?.username
        location.text = Cookies.userInfo()?.location
        phone.text = Cookies.userInfo()?.contact
        communication.text = Cookies.userInfo()?.key_skills
        linkedIn.text = Cookies.userInfo()?.linkedin
        if (Cookies.userInfo() != nil) {
            let imageURL = URL.init(string: Cookies.userInfo()!.image)
            
            if imageURL != nil{
                Nuke.loadImage(with: imageURL!, into: userImage)
            }
          
        }
        
    
        
    }
    
    @IBAction func edit(_ sender: Any) {
    }
    @IBAction func changePassword(_ sender: UIButton) {
    }

}
