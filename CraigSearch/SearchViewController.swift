//
//  ViewController.swift
//  CraigSearch
//
//  Created by Calvin Nisbet on 2015-05-01.
//  Copyright (c) 2015 Calvin Nisbet. All rights reserved.
//Page 63

import UIKit


class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    let search = Searches()
    var landscapeViewController: LandscapeViewController?
    
    
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell,
            bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier:
            TableViewCellIdentifiers.loadingCell)
        
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
   performSearch()
    }
    
    override func willTransitionToTraitCollection(
        newCollection: UITraitCollection,
        withTransitionCoordinator coordinator:
        UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(
        newCollection, withTransitionCoordinator: coordinator)
        switch newCollection.verticalSizeClass {
    case .Compact:
        showLandscapeViewWithCoordinator(coordinator)
    case .Regular, .Unspecified:
        hideLandscapeViewWithCoordinator(coordinator)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            let indexPath = sender as! NSIndexPath
            let searchResult = search.searchResults[indexPath.row]
            detailViewController.searchResult = searchResult
        }
    }
    //LandscapeView Methods
    func showLandscapeViewWithCoordinator(
            coordinator: UIViewControllerTransitionCoordinator) {
            precondition(landscapeViewController == nil)
            landscapeViewController = storyboard!.instantiateViewControllerWithIdentifier(
            "LandscapeViewController") as? LandscapeViewController
            
            if let controller = landscapeViewController {
                    controller.search = search
                    controller.view.frame = view.bounds
                    controller.view.alpha = 0
                    view.addSubview(controller.view)
                    addChildViewController(controller)
        
                    coordinator.animateAlongsideTransition({ _ in
                controller.view.alpha = 1
                if self.presentedViewController != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
                }
                self.searchBar.resignFirstResponder()
                }, completion: { _ in
                controller.didMoveToParentViewController(self)
                })
            }
    }
    
    
    func hideLandscapeViewWithCoordinator(
                coordinator: UIViewControllerTransitionCoordinator) {
                if let controller = landscapeViewController {
                controller.willMoveToParentViewController(nil)
        
                coordinator.animateAlongsideTransition({ _ in
                controller.view.alpha = 0
                }, completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParentViewController()
                self.landscapeViewController = nil
                })
            }
    }
    
    //Other Methods
   
    
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error reading from the iTunes Store. Please try again.",
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func performSearch() {
        search.performSearchForText(searchBar.text, category: segmentedControl.selectedSegmentIndex, completion: { successful in
        if !successful {
        self.showNetworkError()
        }
        self.tableView.reloadData()
    })
        tableView.reloadData()
        searchBar.resignFirstResponder()
}

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearch()
    }
        
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}




extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if search.isLoading {
    return 1
    } else if !search.hasSearched {
            return 0
        } else if search.searchResults.count == 0 {
            return 1
        } else {
            return search.searchResults.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if search.isLoading {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath:indexPath) as! UITableViewCell
        
        let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            
            
        return cell
        
    } else if search.searchResults.count == 0 {
        return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath) as! UITableViewCell
        
    } else {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
        
        let searchResult = search.searchResults[indexPath.row]
        cell.configureForSearchResult(searchResult)
        
        return cell
        }
    }
}





extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if search.searchResults.count == 0 || search.isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}





