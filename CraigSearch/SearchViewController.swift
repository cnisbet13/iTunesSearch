//
//  ViewController.swift
//  CraigSearch
//
//  Created by Calvin Nisbet on 2015-05-01.
//  Copyright (c) 2015 Calvin Nisbet. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        hasSearched = true
        searchResults = [SearchResult]()
        
        if searchBar.text != "justin bieber" {
            for i in 0...2 {
                let searchResult = SearchResult()
                searchResult.name = String(format: "Fake Result %d for", i)
                searchResult.artistName = searchBar.text
                searchResults.append(searchResult)
            }
        }
        
        tableView.reloadData()
    }
        func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
            return .TopAttached
        }
}


extension SearchViewController : UITableViewDelegate {
    
}

extension SearchViewController :UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SearchResultCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        if searchResults.count == 0 {
            cell.textLabel!.text = "(Nothing found)"
            cell.detailTextLabel!.text = ""
        } else {
        let searchResponse = searchResults[indexPath.row]
        cell.textLabel!.text = searchResponse.name
        cell.detailTextLabel!.text = searchResponse.artistName
        }
        return cell
    }
}
        


