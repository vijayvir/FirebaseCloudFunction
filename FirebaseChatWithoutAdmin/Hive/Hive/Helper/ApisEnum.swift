//
//  ApisEnum.swift
//  Hive
//
//  Created by Nitish Sharma on 12/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import Foundation

enum HiveApi  : String{
    case signUp  = "http://hive.techangouts.com:4001/user_signup"
    case login = "http://hive.techangouts.com:4001/user_login"
    case updateUserProfile = "http://hive.techangouts.com:4001/update_user_profile"
    case userListing = "http://hive.techangouts.com:4001/user_list"
    case public_group_list = "http://hive.techangouts.com:4001/public_group_list"
    case userPublicGroup = "http://hive.techangouts.com:4001/user_public_group"
    
}
func isSuccess(json : [String : Any]) -> Bool{
    
    if let isSucess = json["success"] as? Int {
        if isSucess == 200{
                return true
        }
    }
    return false
}
func message(json : [String : Any]) -> String{
    if let message = json["body"] as? String {
        return message
    }
   return ""
}
