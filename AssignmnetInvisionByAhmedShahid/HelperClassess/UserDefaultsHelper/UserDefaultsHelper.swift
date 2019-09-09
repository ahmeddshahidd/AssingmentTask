//
//  UserDefaultsHelper.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 09/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import Foundation
import CoreData

class UserDefaultsHelper: NSObject {
    static let shared = UserDefaultsHelper()
    var searchResult: [String]? = [String]()
    
    private override init() {
        if let searchResultArray = Constants.USER_DEFAULTS.array(forKey: UserDefaultKeys.searchArray) as? [String] {
            self.searchResult = searchResultArray
        }
    }
    
    public func addToSearchResult(with searchKeyword: String) {
        if self.searchResult?.contains(where: {$0 == searchKeyword}) ?? true {
            return
        } else {
            if searchResult?.count == 10 {
                searchResult?.removeFirst()
            }
            searchResult?.append(searchKeyword)
            Constants.USER_DEFAULTS.set(searchResult, forKey: UserDefaultKeys.searchArray)
        }

    }
    
    public func getListOfSearchResult() -> [String] {
        if (self.searchResult?.count ?? 0) > 0 {
            return self.searchResult ?? [String]()
        } else {
            if let searchResultArray = Constants.USER_DEFAULTS.array(forKey: UserDefaultKeys.searchArray) as? [String] {
                self.searchResult = searchResultArray
            }
        }
        return [String]()
    }
}
