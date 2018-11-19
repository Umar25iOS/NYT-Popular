//
//  AppNetworking.swift
//  NYTimes
//
//  Created by Mohammad Umar Khan on 19/11/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
//import SWMessages

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]


extension Notification.Name {

    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
}

enum AppNetworking {
    
    static func POST(endPoint : String,
                     parameters : JSONDictionary = [:],
                     images : [String: UIImage]? = nil,
                     headers : JSONDictionary = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {

        
        request(URLString: endPoint, httpMethod: .post, parameters: parameters, images: images, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func POSTT(endPoint : String,
                     parameters : JSONDictionary = [:],
                     images: [String: UIImage]? = nil,
                     headers : JSONDictionary = [:],
                     loader : Bool = true,
                     success : @escaping (JSON) -> Void,
                     failure : @escaping (Error) -> Void) {
        
        requesttttt(URLString: endPoint, httpMethod: .post, parameters: parameters, images: images, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func GET(endPoint : String,
                    parameters : JSONDictionary = [:],
                    headers : JSONDictionary = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    
    static func PUT(endPoint : String,
                    parameters : JSONDictionary = [:],
                    images: [String: UIImage]? = nil,
                    headers : JSONDictionary = [:],
                    loader : Bool = true,
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .put, parameters: parameters, images: images, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    static func DELETE(endPoint : String,
                       parameters : JSONDictionary = [:],
                       headers : JSONDictionary = [:],
                       loader : Bool = true,
                       success : @escaping (JSON) -> Void,
                       failure : @escaping (Error) -> Void) {
        
        request(URLString: endPoint, httpMethod: .delete, parameters: parameters, headers: headers, loader: loader, success: success, failure: failure)
    }
    
    
    
    private static func requesttttt(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                images: [String: UIImage]? = nil,
                                encoding: URLEncoding = .methodDependent,
                                headers : JSONDictionary = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
//        var additionalHeaders = headers as? HTTPHeaders
        
        if loader { showLoader() }
        
        let url = URL(string: URLString)

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        
        request.addValue(headers["Authorization"] as! String, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { (response:DataResponse<Any>) in
            
            if loader { hideLoader() }
            parseResponse(response, success: success, failure: failure)
        }
    }
    
    private static func request(URLString : String,
                                httpMethod : HTTPMethod,
                                parameters : JSONDictionary = [:],
                                images: [String: UIImage]? = nil,
                                encoding: URLEncoding = .methodDependent,
                                headers : JSONDictionary = [:],
                                loader : Bool = true,
                                success : @escaping (JSON) -> Void,
                                failure : @escaping (Error) -> Void) {
        
        
        if Globals.isConnectedToNetwork == false {
            
            print("Please check your internet connection.")
            //CommonFunction.showToast(toast: "Please check your internet connection.")
            return
            
        }
        
        var additionalHeaders = headers as? HTTPHeaders
        
        let additionalParameters = parameters
        
        if loader { showLoader() }
        
        if let unwrappedImages = images, unwrappedImages.count > 0 {
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                var index = 0
                for (key, image) in unwrappedImages {
                    defer { index += 1 }
                    guard let imgData = UIImageJPEGRepresentation(image, 0.6) else { continue }
                    
                    multipartFormData.append(imgData, withName: "Images[]", fileName: "\(key).jpeg", mimeType: "image/jpeg")
                }
                
                for (key , value) in additionalParameters {
                    
                    if value is JSONDictionary || value is Array<Any> {
                        
                        let jsonObject = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions(rawValue: 0))
                        let jsonString = NSString(data: jsonObject!, encoding: String.Encoding.utf8.rawValue) ?? ""
                        multipartFormData.append((jsonString as AnyObject).data(using : String.Encoding.utf8.rawValue)!, withName: key)
                    } else {
                        multipartFormData.append((value as AnyObject).data(using : String.Encoding.utf8.rawValue)!, withName: key)
                    }
                }
            }, to: URLString, method: httpMethod, headers: additionalHeaders, encodingCompletion: { (result) in
                parseEncodingResult(result, loader: loader, success: success, failure: failure)
            })
            
        } else {
            
            
            Alamofire.request(URLString, method: httpMethod,
                              parameters: additionalParameters,
                              encoding: encoding,
                              headers: additionalHeaders).responseJSON { (response:DataResponse<Any>) in
                                
                                if loader { hideLoader() }
                                parseResponse(response, success: success, failure: failure)
            }
        }
    }
    
    private static func parseEncodingResult(_ result: SessionManager.MultipartFormDataEncodingResult,
                                            loader: Bool = true,
                                            success : @escaping (JSON) -> Void,
                                            failure : @escaping (Error) -> Void) {
        
        switch result {
            
        case .success(let upload, _, _):
            
            upload.responseJSON { (response:DataResponse<Any>) in
                
                if loader { hideLoader() }
                
                parseResponse(response, success: success, failure: failure)
            }
            
        case .failure(let encodingError):
            
            if loader { hideLoader() }
            
            failure(encodingError)
        }
    }
    
    private static func parseResponse(_ response: DataResponse<Any>,
                                      success : @escaping (JSON) -> Void,
                                      failure : @escaping (Error) -> Void) {
        
        /*
         String(data: response.data!, encoding: String.Encoding.utf8)
         */
        
        switch(response.result) {
            
        case .success(let value):
            
            //Globals.printlnDebug(value)
            let data = JSON(value)
            
            if let code = data["CODE"].int, code == 412 {
                //manage accordingly
                //CommonFunction.showToast(toast: NSLocalizedString("access_token_expire", comment: ""))
                //CurrentUser.logout() uncomment this..
            } else {
                success(JSON(value))
            }
            
        case .failure(let e):
            
                        //Globals.printlnDebug(String(data: response.data!, encoding: String.Encoding.utf8))
            
            let err = (e as NSError)
            
            if err.code == NSURLErrorNotConnectedToInternet || err.code == NSURLErrorInternationalRoamingOff {
                
                // Handle Internet Not available UI
                NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                
                let internetNotAvailableError = NSError(code: NSURLErrorNotConnectedToInternet, localizedDescription: "")
                failure(internetNotAvailableError)
                
            } else {
                failure(e)
            }
        }
        
    }
    
}
