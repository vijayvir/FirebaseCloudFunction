//
//  UserDefault.swift
//  Hive
//
//  Created by Nitish Sharma on 13/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import Foundation

extension NSDictionary {
    var id : Int {
        return self["id"] as!Int
    }
    var email : String {
        return self["id"] as!String
    }
    var username : String {
        return self["username"] as!String
    }
    var contact : String{
         return self["contact"] as!String
    }
    var location : String{
        return self["location"] as!String
    }
    var key_skills : String{
        return self["key_skills"] as!String
    }
    var linkedin : String{
        return self["linkedin"] as!String
    }
    var image : String{
        return self["image"] as?String ?? "profileDefault"
    }
}
class Cookies {
    class func userInfoSave( dict : [String : Any]? = nil){
         UserDefaults.standard.set( dict, forKey: "userInfoSave")
         UserDefaults.standard.synchronize()
    }
    class func userInfo() -> NSDictionary? {
        if let   some =  UserDefaults.standard.object(forKey: "userInfoSave") as? NSDictionary {
            return some
        }
        return nil
    }
}

extension UserDefaults {
    
    /// Private key for persisting the active Theme in UserDefaults
    private static let FirebaseToken = "FirebaseToken"

    /// Retreive theme identifer from UserDefaults
    public func firebaseToken() -> String? {
        return self.string(forKey: UserDefaults.FirebaseToken)
    }
    
    /// Save theme identifer to UserDefaults
    public func firebaseToken(_ identifier: String?) {
        self.set(identifier, forKey: UserDefaults.FirebaseToken)
    }
    
}







