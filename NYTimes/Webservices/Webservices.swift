//
//  Webservices.swift
//
//  NYTimes
//
//  Created by Mohammad Umar Khan on 19/11/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum WebServices { }

extension NSError {
    
    convenience init(localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

extension WebServices {
    
    // MARK: - Newyork times most popular list API
    
    static func viewAllNewyorkTimesmostPopularList(param: JSONDictionary, viewAllNewyorkTimesCompleted: @escaping (JSON)-> (), failure: @escaping (Error)-> Void){
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.apiKey.url, parameters: param, headers: [:], loader: false, success: { (jsonData) in
            
            if jsonData["status"].stringValue == "OK"{
                
                viewAllNewyorkTimesCompleted(jsonData)
            }
            else {
                let e = NSError(localizedDescription: "Something went wrong, please try again later.")
                
                failure(e)
            }
        }) { (err) in
            failure(err)
        }
    }

} // EOM Webservices...

