//
//  Constants.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 08/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//


import UIKit

struct Constants {
    
    static let APP_DELEGATE                  = UIApplication.shared.delegate as! AppDelegate
    static let UIWINDOW                      = UIApplication.shared.delegate!.window!
    
    static let USER_DEFAULTS                 = UserDefaults.standard
    
    static let SINGLETON                     = Singleton.shared
    
    static let filePath                      = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    static let BASEURL                       = "http://api.themoviedb.org/3/"
    static let IMAGE_BASEURL                 = "http://image.tmdb.org/t/p/w92"
    static let API_KEY                       = "2696829a81b1b5827d515ff121700838"
}

struct UserDefaultKeys {
    static let searchArray = "SearchArray"
}
