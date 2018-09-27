//
//  ViewController.swift
//  Hive
//
//  Created by Nitish Sharma on 04/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//
import UIKit
import IBAnimatable
class HVLoginViewController: HVGenricViewController {
    @IBOutlet weak var emailTextField: AnimatableTextField!
    @IBOutlet weak var passwordTextField: AnimatableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Cookies.userInfo() != nil) {
            let vc  : CustomSideMenuController = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuController") as! CustomSideMenuController
            self.present(vc, animated: false, completion: nil)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Actions
    @IBAction func forgotPassword(_ sender: UIButton) {
        
    }
    @IBAction func login(_ sender: AnimatableButton) {

       self.view.endEditing(true)
        
        if emailTextField.text!.count <= 0 {
            Alert.showSimple("Please enter email address.") {

            }
            return
        }
        if passwordTextField.text!.count <= 0 {
            Alert.showSimple("Please enter password.") {

            }
             return
        }


        func isValidEmailAddress(emailAddressString: String) -> Bool {

            var returnValue = true
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"

            do {
                let regex = try NSRegularExpression(pattern: emailRegEx)
                let nsString = emailAddressString as NSString
                let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))

                if results.count == 0
                {
                    returnValue = false
                }

            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }

            return  returnValue
        }

        if !isValidEmailAddress(emailAddressString: emailTextField.text!){
            Alert.showSimple("Please enter valid email address.") {

            }
             return
        }
        
        
        if !isConnectedToInternet(){
            Alert.showSimple("Please connect to internet")
            return
        }
        
        
        Hud.show(message: "", view: view)
        var request : [String:Any] = [:]
        request["email"] = emailTextField.text.leoSafe()
        request["password"] = passwordTextField.text.leoSafe()
        WebServices.post(url: .login, jsonObject: request, completionHandler: { (json) in
            Hud.hide(view: self.view)
            if isSuccess(json: json){
                if let body = json["body"] as? NSArray {
                    if let dict = body.firstObject as? [String : Any]{
                        Cookies.userInfoSave(dict: dict)
                        let vc  : CustomSideMenuController = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuController") as! CustomSideMenuController
                        self.present(vc, animated: false, completion: nil)
                    }}
            }else {
                Alert.showSimple(message(json: json))
            }
        },failureHandler: { (json) in
            Hud.hide(view: self.view)
        })

        
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        let vc  : HVSignUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "HVSignUpViewController") as! HVSignUpViewController
        
       // self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension HVLoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true 
    }
}

