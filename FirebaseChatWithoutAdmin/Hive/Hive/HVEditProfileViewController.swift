//
//  HVEditProfileViewController.swift
//  Hive
//
//  Created by Nitish Sharma on 07/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//
import UIKit
import Nuke
class HVEditProfileViewController: HVGenricViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var contactDetails: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var linkedInProfile: UITextField!
    @IBOutlet weak var keySkills: UITextField!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var editPhoto: UIPhotosButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = Cookies.userInfo()?.username
        location.text = Cookies.userInfo()?.location
        contactDetails.text = Cookies.userInfo()?.contact
        keySkills.text = Cookies.userInfo()?.key_skills
        linkedInProfile.text = Cookies.userInfo()?.linkedin

   
       
        
        if (Cookies.userInfo() != nil) {
            
            #if targetEnvironment(simulator)
            userName.text = "\(Cookies.userInfo()!.id)"
            #endif
            
             let imageURL = URL.init(string: Cookies.userInfo()!.image)
            if imageURL != nil {
                 Nuke.loadImage(with: imageURL!, into: userImage)
            }
           
        }
        
        
        editPhoto.closureDidFinishPickingAnImage = { image in
            print(image)
            DispatchQueue.main.async {
                let url : URL = URL(fileURLWithPath: image.first!)
                Nuke.loadImage(with: url, into: self.userImage)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func save(_ sender: UIButton) {
        if !isConnectedToInternet(){
            Alert.showSimple("Please connect to internet")
            return
        }
        Hud.show(message: "updating profile", view: view)
        var request : [String:Any] = [:]
    
        request["user_id"] = Cookies.userInfo()?.id
        request["contact"] =  contactDetails.text.leoSafe()
        request["location"] = location.text.leoSafe()
        request["key_skill"] = keySkills.text.leoSafe()
        request["linkedin"] = linkedInProfile.text.leoSafe()
        
        WebServices.uploadSingle(url: .updateUserProfile, jsonObject: request, profiePic: self.userImage.image!, completionHandler: { (json) in
            Hud.hide(view: self.view)
            
            if isSuccess(json: json){
                Alert.showSimple("Updated!")
           
                if let body = json["body"] as? NSArray {
                    if let dict = body.firstObject as? [String : Any]{
                        Cookies.userInfoSave(dict: dict)
                        User.updateProfilePicLink(forUserID: "\(Cookies.userInfo()!.id)" ,imageURl :Cookies.userInfo()!.image)
                             NotificationCenter.default.post(name: Notification.Name("HiveUpdateProfilePic"), object: nil)
                        
                    }}
            }else {
                Alert.showSimple(message(json: json))
            }
        },failureHandler: { (json) in
            Hud.hide(view: self.view)
        })

        
        
   
        
    }


}
