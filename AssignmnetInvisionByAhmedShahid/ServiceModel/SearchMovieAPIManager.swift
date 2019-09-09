//
//  SearchMovieAPIManager.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 08/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import Foundation
import Alamofire
class SearchMovieAPIManager: APIManagerBase {
    
    func getMovieSearch(with param: [String : Any],
                        success:@escaping (SearchModel) -> Void,
                        failure:@escaping DefaultAPIFailureClosure) {
        let route = self.URLforRoute(route: Route.searchMovie.url(), params: param)
        self.getRequestWith(route: route! as URL, success: { (responseJSON) in
            let data = responseJSON.rawString()?.data(using: .utf8)!
            let decoder = JSONDecoder()
            do{
                let jsonData = try decoder.decode(SearchModel.self , from: data!)
                success(jsonData)
            }catch let e {
                failure(e as NSError)
            }
        }, failure: failure)
    }
    
}
