//
//  APIManagerBase.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 08/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Route: String {
    case searchMovie = "search/movie?"
    func url() -> String{
        return Constants.BASEURL + self.rawValue
    }
}

class APIManagerBase: NSObject {
    
    let baseURL = Constants.BASEURL
    let defaultRequestHeader = ["Content-Type": "application/json"]
    let defaultError = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Request Failed."])
    
    func getAuthorizationHeader () -> Dictionary<String,String>{
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
    func getErrorFromResponseData(data: Data) -> NSError? {
        do{
            let result = try JSONSerialization.jsonObject(with: data,options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Dictionary<String,AnyObject>>
            if let message = result?[0]["message"] as? String{
                let error = NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                return error;
            }
        }catch{
            NSLog("Error: \(error)")
        }
        return nil
    }
    
    func URLforRoute(route: String,params:[String: Any]) -> NSURL? {
        
        if let components: NSURLComponents  = NSURLComponents(string: (route)){
            var queryItems = [NSURLQueryItem]()
            for(key,value) in params {
                queryItems.append(NSURLQueryItem(name:key,value: "\(value)"))
            }
            
            components.queryItems = queryItems as [URLQueryItem]?
            
            return components.url as NSURL?
        }
        return nil;
    }
    
    func POSTURLforRoute(route:String) -> URL?{
        
        if let components: NSURLComponents = NSURLComponents(string: (Constants.BASEURL+route)){
            return components.url! as URL
        }
        return nil
    }
    
    func GETURLfor(route:String) -> URL?{
        
        if let components: NSURLComponents = NSURLComponents(string: (Constants.BASEURL+route)){
            return components.url! as URL
        }
        return nil
    }
    
    func postRequestWithMultipart(route: URL,parameters: Parameters,
                                  success:@escaping DefaultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure) {
        
        Alamofire.upload (
            multipartFormData: { multipartFormData in
                for (key , value) in parameters {
                    if let data:Data = value as? Data {
                        multipartFormData.append(data, withName: key, fileName: self.getUniqeImageName(), mimeType: "image/png")
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
                print("multipartFormData: \(multipartFormData)")
        },
            usingThreshold:UInt64.init(),
            to: route,
            headers: getAuthorizationHeader(),
            encodingCompletion: { result in
                switch result {
                case .success(let upload, _,_ ):
                    upload.responseJSON { response in
                        self.responseResult(response, success: {result in
                            success(result as! Dictionary<String, AnyObject>)
                        }, failure: {error in
                            failure(error)
                        })
                    }
                case .failure(let encodingError):
                    failure(encodingError as NSError)
                }
        }
        )
    }
    
    func postRequestWith(route: URL,parameters: Parameters,
                         success:@escaping DefaultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure) {
        Alamofire.request(route, method: .post, parameters: parameters, encoding: URLEncoding.default/* JSONEncoding.default*/, headers: self.getAuthorizationHeader()).responseJSON { response in
            
            self.responseResult(response, success: {response in
                
                success(response as! Dictionary<String, AnyObject>)
            }, failure: {error in
                
                failure(error as NSError)
            })
        }
    }
    
//    func getRequestWith(route: URL,
//                        success:@escaping DefaultAPISuccessClosure,
//                        failure:@escaping DefaultAPIFailureClosure){
//        
//        Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
//            response in
//            
//            self.responseResult(response, success: {response in
//                
//                success(response as! Dictionary<String, AnyObject>)
//            }, failure: {error in
//                
//                failure(error as NSError)
//            })
//        }
//    }
//    
//    func getRequestWith(route: URL,
//                        success:@escaping DefaultArrayResultAPISuccessClosure,
//                        failure:@escaping DefaultAPIFailureClosure){
//        
//        Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
//            response in
//            
//            self.responseResult(response, success: {response in
//                
//                success(response as! NSArray)
//            }, failure: {error in
//                
//                failure(error as NSError)
//            })
//        }
//    }
    
    func getRequestWith(route: URL,
                        success:@escaping DefaultJSONResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .get, encoding: JSONEncoding.default, headers: getAuthorizationHeader()).responseJSON{
            response in
            
            self.responseResult(response, success: {response in
                
                success(response as! JSON)
            }, failure: {error in
                
                failure(error as NSError)
            })
        }
    }
    
    func putRequestWith(route: URL,parameters: Parameters,
                        success:@escaping DefaultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .put, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            
            self.responseResult(response, success: {response in
                
                success(response as! Dictionary<String, AnyObject>)
            }, failure: {error in
                
                failure(error as NSError)
            })
        }
    }
    
    func deleteRequestWith(route: URL,parameters: Parameters,
                           success:@escaping DefaultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        Alamofire.request(route, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            
            self.responseResult(response, success: {response in
                
                success(response as! Dictionary<String, AnyObject>)
            }, failure: {error in
                
                failure(error as NSError)
            })
        }
    }
    
    //MARK: - Response Handling
    func responseResult(_ response:DataResponse<Any>,
                        success: @escaping (_ response: AnyObject) -> Void,
                        failure: @escaping (_ error: NSError) -> Void
        ) {
        switch response.result
        {
        case .success(let json):
            
            let jsonResponse = JSON.init(json)
            let errorCode:Int = (jsonResponse["status_code"].int) ?? 0;
            
            if ((jsonResponse["success"].bool) != nil) {
                //Failure
                let errorMessage: String = (jsonResponse["status_message"].string) ?? "Unknown error";
                let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
                
                let error = NSError(domain: "Domain", code: errorCode, userInfo: userInfo)
                failure(error)
                
            } else {
                //Success
                success(jsonResponse as AnyObject)
            }
        case .failure(let error):
            failure(error as NSError)
        }
    }
    
    fileprivate func getUniqeImageName() -> String {
        let dateforamtter = DateFormatter()
        dateforamtter.dateFormat = "yyyyMMdd'T'HHmmss"
        return "\(dateforamtter.string(from: Date())).png"
    }
    
    fileprivate func multipartFormData(parameters: Parameters) {
        let formData: MultipartFormData = MultipartFormData()
        if let params:[String:AnyObject] = parameters as [String : AnyObject]? {
            for (key , value) in params {
                
                if let data:Data = value as? Data {
                    formData.append(data, withName: key, fileName: self.getUniqeImageName(), mimeType: data.mimeType)
                } else {
                    formData.append("\(value)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                }
            }
        }
    }
}


public extension Data {
    var mimeType:String {
        get {
            var c = [UInt32](repeating: 0, count: 1)
            (self as NSData).getBytes(&c, length: 1)
            switch (c[0]) {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            case 0x49, 0x4D:
                return "image/tiff";
            case 0x25:
                return "application/pdf";
            case 0xD0:
                return "application/vnd";
            case 0x46:
                return "text/plain";
            default:
                print("mimeType for \(c[0]) in available");
                return "application/octet-stream";
            }
        }
    }
}
