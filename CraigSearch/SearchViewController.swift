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
    
    var searchResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


    extension SearchViewController : UISearchBarDelegate {
        func searchBarButtonClicked(searchBar: UISearchBar) {
        searchResults = [String]()
            
            for i in 0...2 {
                searchResults.append(String(format: "Fake Result %d for '%@'", i, searchBar.text))
            }
            tableView.reloadData()
}
}


extension SearchViewController : UITableViewDelegate {
    
}

extension SearchViewController :UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
        


