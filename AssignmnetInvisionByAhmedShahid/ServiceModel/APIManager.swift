//
//  APIManager.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 08/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import Foundation
import SwiftyJSON
typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void
typealias DefaultArrayResultAPISuccessClosure = (NSArray) -> Void
typealias DefaultJSONResultAPISuccessClosure = (JSON) -> Void


protocol APIErrorHandler {
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromERror(error:NSError)
}


class APIManager: NSObject {
    
    
    static let sharedInstance = APIManager()
    
    
    var serverToken: String? {
        get{
            return ""
        }
        
    }
    
    let searchMovieAPIManager = SearchMovieAPIManager()
    
}
