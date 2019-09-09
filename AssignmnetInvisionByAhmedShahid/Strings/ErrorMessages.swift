//
//  ErrorMessages.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 09/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import Foundation

enum ErrorTitle: String {
    case Failed = "Failed"
    case noInternet = "No Internet Available"
    
    func messageStrign() -> String {
        return self.rawValue
    }
}

enum ErrorMessages: String {
    case searchFail = "Sorry, we are unable to fetch your searched movie at the moment."
    
    func messageStrign() -> String {
        return self.rawValue
    }
}
