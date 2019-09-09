//
//  ViewController.swift
//  AssignmnetInvisionByAhmedShahid
//
//  Created by Ahmed Shahid on 07/09/2019.
//  Copyright © 2019 Ahmed Shahid. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var textfieldSearch: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    var searchObject: SearchModel? = nil
    var pageNumber: Int? = 1
    var showLastSearches = false
    var isFetchingData: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Search Movie"
        // set textfield placeholder color
        let color = UIColor.white
        self.textfieldSearch.attributedPlaceholder = NSAttributedString(string: "Search Movie Here...", attributes: [
            NSAttributedString.Key.foregroundColor: color
            ])
        self.textfieldSearch.delegate = self
        
        self.tableview.reloadData()
    }
    
    // MARK: - HELPING METHODS
    func tableViewScrollTo(index: Int, postion: UITableView.ScrollPosition) {
        if (self.searchObject?.results?.count ?? 0) > index {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableview.scrollToRow(at: indexPath, at: postion, animated: true)
        }
        
    }
    // MARK: - IB ACTIONS
    @IBAction func actionSearchBtn(_ sender: Any) {
        if self.textfieldSearch.text?.isEmpty ?? true {
            return
        }

        self.searchObject = nil
        self.pageNumber = 1
        self.textfieldSearch.resignFirstResponder()
        self.search(with: self.textfieldSearch.text ?? "")
    }
    @IBAction func actionTextFieldEditingBegins(_ sender: Any) {
        self.showLastSearches = true
        self.tableview.reloadData()
    }
}
// MARK: - API CALLING
extension SearchViewController {
    func search(with searchText: String) {
        let param: [String : Any] = [
            "api_key" : Constants.API_KEY,
            "query" : searchText,
            "page" : pageNumber ?? 1
        ]
        
        Utility.shared.showLoader()
        self.isFetchingData = true
        APIManager.sharedInstance.searchMovieAPIManager.getMovieSearch(with: param, success: { (searchResult) in
            
            if self.searchObject == nil {
                // searching for first time
                self.searchObject = searchResult
                self.showLastSearches = false
                if (self.searchObject?.results?.count ?? 0) == 0 {
                    Utility.shared.showLabelIfNoData(withtext: "No Data Found", controller: self, tableview: self.tableview)
                } else {
                    Utility.shared.showLabelIfNoData(withtext: "", controller: self, tableview: self.tableview)
                }
                self.tableview.reloadData()
                self.tableViewScrollTo(index: 0, postion: .top)
            } else {
                // scrolling to reload more
                var previousMovieListWithNew = self.searchObject?.results
                for movie in (searchResult.results ?? [MovieResults]()) {
                    previousMovieListWithNew?.append(movie)
                }
                self.searchObject = searchResult
                self.searchObject?.results = previousMovieListWithNew
                
                self.showLastSearches = false
                if (self.searchObject?.results?.count ?? 0) == 0 {
                    Utility.shared.showLabelIfNoData(withtext: "No Data Found", controller: self, tableview: self.tableview)
                } else {
                    Utility.shared.showLabelIfNoData(withtext: "", controller: self, tableview: self.tableview)
                }
                 self.tableview.reloadData()
            }
            UserDefaultsHelper.shared.addToSearchResult(with: searchText)
            Utility.shared.hideLoader()
            self.isFetchingData = false
        }) { (err) in
            print("\(err.localizedDescription)")
            Utility.shared.hideLoader()
            self.isFetchingData = false
            Utility.shared.showAlert(message: ErrorMessages.searchFail.messageStrign(), title: ErrorTitle.Failed.messageStrign(), controller: self)
        }
    }
}
//MARK: - UITextField Delegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textfieldSearch.resignFirstResponder()
        return true
    }
}

// MARK: - UITableView DataSource & Delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showLastSearches {
            return UserDefaultsHelper.shared.searchResult?.count ?? 0
        } else {
            return self.searchObject?.results?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.showLastSearches {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchKeywordCell") else {
                return UITableViewCell()
            }
            if let label = cell.viewWithTag(101) as? UILabel {
                label.text = UserDefaultsHelper.shared.searchResult?[indexPath.row]
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchCell") as? MovieSearchCell else {
                return UITableViewCell()
            }
            cell.bindData(with: self.searchObject?.results?[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.showLastSearches {
            self.searchObject = nil
            self.pageNumber = 1
            self.textfieldSearch.resignFirstResponder()
            self.textfieldSearch.text = UserDefaultsHelper.shared.searchResult?[indexPath.row]
            self.search(with: UserDefaultsHelper.shared.searchResult?[indexPath.row] ?? "")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = Float(scrollView.frame.size.height)
        let scrollContentSizeHeight = Float(scrollView.contentSize.height)
        let scrollOffset = Float(scrollView.contentOffset.y)
        
        if scrollOffset == 0 {
            // then we are at the top
        } else if scrollOffset + scrollViewHeight == scrollContentSizeHeight {
            if !(self.textfieldSearch.text?.isEmpty ?? true) && !(self.isFetchingData ?? false) {
                if (self.searchObject?.page ?? 1) < (self.searchObject?.total_pages ?? 1) {
                    self.pageNumber = (self.searchObject?.page ?? 0) + 1
                    self.search(with: self.textfieldSearch.text ?? "")
                }
            }
        }
    }
    
}

