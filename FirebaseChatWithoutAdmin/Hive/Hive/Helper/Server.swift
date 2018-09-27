//
//  WebServices.swift
//  MedicalApp
//
//  Created by Apple on 12/12/16.
//  Copyright © 2016 vijayvirSingh. All rights reserved.
//
import Foundation
import Alamofire
typealias CompletionBlock = ([String : Any]) -> Void
typealias FailureBlock = ([String : Any]) -> Void
// ((Swift.Int) -> Swift.Void)? = nil )
// http://fuckingswiftblocksyntax.com
/// https://www.raywenderlich.com/121540/alamofire-tutorial-getting-started
func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
}
class WebServices {
    class func post( url : HiveApi,jsonObject: [String : Any]  , method : HTTPMethod? = .post , completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        let urlString = url.rawValue
        let parameters: Parameters = jsonObject
        Alamofire.request(urlString, method: method!, parameters: parameters)
            .responseJSON {
                response in
                switch (response.result) {
                case .success(let value):
                    completionHandler!(value as! [String : Any] )
                case .failure(let error):
                    print(error)
                    failureHandler?([:] )
                }
            }
            .responseString { _ in
            }
            .responseData { response in
                if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                    // print("Data: \(utf8Text)")
                }
        }
    }
    
    class func uploadSingle( url : HiveApi,jsonObject: [String : Any] , profiePic:UIImage , completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        let urlString = url.rawValue
        
        let parameters: Parameters = jsonObject
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            let data = UIImageJPEGRepresentation(profiePic, 1)!
            
            multipartFormData.append(data, withName: "profile_image", fileName: "\(NSUUID().uuidString).jpeg", mimeType: "image/jpeg")
        
            for (key, value) in parameters {
              multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
             }
        
         },
            to: urlString) { result  in
                                switch result {
                                case .success(let upload, _, _):
    
                                                upload.uploadProgress(closure: { _ in
                                                        // Print progress
                                                })
                                                upload.responseJSON { response in
                                                    switch (response.result) {
                                                    case .success(let value):
                                                        completionHandler!(value as! [String : Any] )
                                                    case .failure(let error):
                                                        print(error)
                                                        failureHandler?([:] )
                                                    }
                                                    
                                    }
                                    
                                case .failure(let encodingError):
                                    print(encodingError)
                }
                                    
                }
    
      
}
    
    }
    
    
    


/*
 class func upload(jsonObject: AnyObject, files: Array<Any>? = nil, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
 Alamofire.upload(multipartFormData: { multipartFormData in
 
 if let filesO = files {
 for i in filesO.enumerated() {
 let image = UIImage(named: "\(i.element)")
 
 let data = UIImageJPEGRepresentation(image!, 1)!
 
 multipartFormData.append(data, withName: "imgFiles[]", fileName: "\(NSUUID().uuidString).jpeg", mimeType: "image/jpeg")
 
 // imgFiles[] give array in Php Side
 
 // imgFiles   will give string in PHP String
 
 }
 
 }
 
 for (key, value) in jsonObject as! [String: String] {
 
 multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
 
 }
 
 },
 to: baseURL) { result
 in
 switch result {
 case .success(let upload, _, _):
 
 upload.uploadProgress(closure: { _ in
 // Print progress
 })
 
 upload.responseJSON { response in
 
 print("JSON: \(response)")
 
 if let json = response.result.value {
 print("JSON: \(json)")
 
 completionHandler!(json as AnyObject, response.result as AnyObject)
 } else {
 failureHandler?("" as AnyObject, "" as AnyObject)
 
 }
 
 }
 case .failure(let encodingError):
 failureHandler?("" as AnyObject, "" as AnyObject)
 print(encodingError)
 
 }
 
 }
 
 }
 */


