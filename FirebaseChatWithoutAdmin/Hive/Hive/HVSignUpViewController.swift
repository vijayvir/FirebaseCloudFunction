//
//  HVSignUpViewController.swift
//  Hive
import IBAnimatable
//https://nshipster.com/uitextinputpasswordrules/
class HVSignUpViewController: HVGenricViewController {
    @IBOutlet weak var nameTxt: AnimatableTextField!
    @IBOutlet weak var passwordTxt: AnimatableTextField!
    @IBOutlet weak var emailTxt: AnimatableTextField!
    @IBOutlet weak var confirmPasswordTxt: AnimatableTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.firebaseToken() != nil  {
            print(UserDefaults.standard.firebaseToken().leoSafe())
            
        }
        //print(UserDefaults.standard.firebaseToken())
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signUp(_ sender: AnimatableButton) {
        
        let random =  arc4random_uniform( 1000)
        
        if nameTxt.text!.count <= 0 {
            Alert.showSimple("Please enter name.") {
            }
            return
        }
        
        if emailTxt.text!.count <= 0 {
            Alert.showSimple("Please enter email address.") {
            }
            return
        }
        if passwordTxt.text!.count <= 0 {
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
                if results.count == 0{
                    returnValue = false
                }
                
            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }
            return  returnValue
        }
        if !isValidEmailAddress(emailAddressString: emailTxt.text!){
            Alert.showSimple("Please enter valid email address.") {
            }
            return
        }
        
        if passwordTxt.text! != confirmPasswordTxt.text!{
            Alert.showSimple("Confirm password should match password.") {
                
            }
            return
        }
        
        if !isConnectedToInternet(){
            Alert.showSimple("Please connect to internet")
            return
        }
        Hud.show(message: "", view: view)
        var request : [String:Any] = [:]
        request["user_name"] =  nameTxt.text.leoSafe()
        request["email"] = emailTxt.text.leoSafe()
        request["password"] = passwordTxt.text.leoSafe()
        request["device_type"] = "device_type\(random)"
        request["device_token"] = "device_token\(random)"
        WebServices.post(url: .signUp, jsonObject: request, completionHandler: { (json) in
            Hud.hide(view: self.view)
            if isSuccess(json: json){
                if let body = json["body"] as? NSArray {
                    if let dict = body.firstObject as? [String : Any]{
                        Hud.show(message: "configure chat", view: self.view)
                        User.registerUser(userId: "\(dict["id"]!)",
                            withName: "\(dict["username"]!)",
                            email: "\(dict["email"]!)",
                        password: "\(dict["password"]!)", profilePic: #imageLiteral(resourceName: "profile pic")){ (isPass) in
                            Hud.hide(view: self.view)
                            if isPass {
                                
                                Cookies.userInfoSave(dict: dict)
                             
                                
                                let vc  : CustomSideMenuController = self.storyboard?.instantiateViewController(withIdentifier: "CustomSideMenuController") as! CustomSideMenuController
                                self.present(vc, animated: false, completion: nil)
                            }else {
                                Alert.showSimple("Some error in chat configure.")
                            }
                        }
                    }
                }
            } else {
                Alert.showSimple("Something wrong happens.")
            }
            
            
        }, failureHandler: { (json) in
            Hud.hide(view: self.view)
        })
        
        return
        
        
    }
    @IBAction func alreadyLogin(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true )
    }
}
extension HVSignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


