//
//  ApisEnum.swift
//  Hive
//
//  Created by Nitish Sharma on 12/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import Foundation

enum HiveApi  : String{
    
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
