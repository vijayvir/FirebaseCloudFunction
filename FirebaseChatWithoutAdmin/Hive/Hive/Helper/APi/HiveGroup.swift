//
//  HiveGroup.swift
//  Hive
//
//  Created by Nitish Sharma on 20/09/18.
//  Copyright © 2018 vijayvir Singh. All rights reserved.
//

import Foundation
import Foundation
class  HiveGroup {

    //{"id":1,"user_id":42,"group_name":"I don’t want ","status":"0","created_at":"2018-09-20T08:01:53.000Z"}
    var group_name : String
    var id : Int?

    init(dict : [String : Any]) {
        self.group_name = dict["group_name"] as? String  ?? ""
        self.id = dict["id"] as? Int
    }
    class func grouplistingInComming(json: [String :Any]) -> ([HiveGroup]) {
        
        var groups : [HiveGroup] = []
        
        if let body = json["body"] as? NSArray {
            
            for user in body {
                if let dict = user as? [String : Any] {
                    
                    let user = HiveGroup(dict: dict)
                     groups.append(user)
                    
                }
            }
            
            
        }
        return groups
    }
}
