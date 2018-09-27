import Foundation
class  HiveUser {
//    contact = "";
//    "created_at" = "2018-09-13T05:07:04.000Z";
//    "device_token" = "device_token231";
//    "device_type" = "device_type231";
//    email = email231;
//    id = 2;
//    image = "";
//    "key_skills" = "";
//    linkedin = "";
//    location = "";
//    "login_status" = 0;
//    password = "$2b$10$UeyEDgNBP2aDhwDCrDxHweDwy5jCN9pTmB64liQLdH00z2UInXvV.";
//    status = 0;
//    username = "user_name231";
   
    var username : String
    var email : String
    var id : Int?
    var image : String?
    init(dict : [String : Any]) {
          self.username = dict["username"] as? String  ?? ""
          self.email = dict["email"] as? String ?? ""
          self.id = dict["id"] as? Int
          self.image = dict["image"] as? String ?? "profileDefault"
        
    }
    class func userlistingInComming(json: [String :Any]) -> ([HiveUser]) {
        
        var users : [HiveUser] = []
        
        if let body = json["body"] as? NSArray {
            
            for user in body {
                if let dict = user as? [String : Any] {
                    
                    let user = HiveUser(dict: dict)
                    if Cookies.userInfo() != nil {
                      
                        if user.id.leoSafe() != Cookies.userInfo()!.id{
                                 users.append(user)
                        }
                        
                    }
                   
            
                }
            }
        
        
        
   
        }
             return users
    }
}
