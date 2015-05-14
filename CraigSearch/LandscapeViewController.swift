//
//  LandscapeViewController.swift
//  CraigSearch
//
//  Created by Calvin Nisbet on 2015-05-13.
//  Copyright (c) 2015 Calvin Nisbet. All rights reserved.
//

import UIKit


class LandscapeViewController: UIViewController


{
    var search: Searches!
    private var firstTime = true
    private var downloadTasks = [NSURLSessionDownloadTask]()
    
    deinit {
        println("deinit \(self)")
        for task in downloadTasks {
        task.cancel()
        }
    }
    
    
    private func tileButtons(searchResults: [SearchResult]) {
            
            var columnsPerPage = 5
            var rowsPerPage = 3
            var itemWidth: CGFloat = 96
            var itemHeight: CGFloat = 88
            var marginX: CGFloat = 0
            var marginY: CGFloat = 20
            
            let scrollViewWidth = scroller.bounds.size.width
            let buttonWidth: CGFloat = 82
            let buttonHeight: CGFloat = 82
            let paddingHorz = (itemWidth - buttonWidth)/2
            let paddingVert = (itemHeight - buttonHeight)/2
            
            var row = 0
            var column = 0
            var x = marginX
           
            for (index, searchResult) in enumerate(searchResults) {
                
                let button = UIButton.buttonWithType(.Custom) as! UIButton
                button.setBackgroundImage(UIImage(named: "LandscapeButton"),
                forState: .Normal)
                downloadImageForSearchResult(searchResult, andPlaceOnButton: button)
                button.frame = CGRect(
                x: x + paddingHorz,
                y: marginY + CGFloat(row)*itemHeight + paddingVert,
                width: buttonWidth, height: buttonHeight)
                scroller.addSubview(button)
                
                ++row
                
                if row == rowsPerPage {
                row = 0
                ++column
                x += itemWidth
                if column == columnsPerPage {
                column = 0
                x += marginX * 2
                }
            }
        }
            
            
            switch scrollViewWidth {
            case 568:
            columnsPerPage = 6
            itemWidth = 94
            marginX = 2
        
            case 667:
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
            
            case 736:
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
            default:
            break
        }
            let buttonsPerPage = columnsPerPage * rowsPerPage
            let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
            scroller.contentSize = CGSize(
                width: CGFloat(numPages)*scrollViewWidth,
                height: scroller.bounds.size.height)
            println("Number of pages: \(numPages)")
            
            pageController.numberOfPages = numPages
            pageController.currentPage = 0
    }
   
    
    override func viewDidLoad() {
                super.viewDidLoad()
                view.removeConstraints(view.constraints())
                view.setTranslatesAutoresizingMaskIntoConstraints(true)
                pageController.removeConstraints(pageController.constraints())
                pageController.setTranslatesAutoresizingMaskIntoConstraints(true)
                scroller.removeConstraints(scroller.constraints())
                scroller.setTranslatesAutoresizingMaskIntoConstraints(true)
                pageController.numberOfPages = 0
                
                scroller.backgroundColor = UIColor(patternImage:
            UIImage(named: "LandscapeBackground")!)
    }
    
    private func downloadImageForSearchResult(searchResult: SearchResult,
                    andPlaceOnButton button: UIButton) {
        if let url = NSURL(string: searchResult.artworkURL60) {
        let session = NSURLSession.sharedSession()
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: { [weak button] url, response, error in
                    if error == nil && url != nil {
                    if let data = NSData(contentsOfURL: url) {
                    if let image = UIImage(data: data) {
                    dispatch_async(dispatch_get_main_queue()) {
                    if let button = button {
                    button.setImage(image, forState: .Normal)
                    }
                    }
                }
                }
                }
                    })
                    downloadTasks.append(downloadTask)
                    downloadTask.resume()
                    }
    }
    
    
    override func viewWillLayoutSubviews() {
                super.viewWillLayoutSubviews()
                scroller.frame = view.bounds
                pageController.frame = CGRect(
                x: 0,
                y: view.frame.size.height - pageController.frame.size.height,
                width: view.frame.size.width,
                height: pageController.frame.size.height)
                
                if firstTime {
                    firstTime = false
                    tileButtons(search.searchResults)
                }
    }
    
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
  
    
    
    @IBAction func pageChanged(sender: UIPageControl) {
                    UIView.animateWithDuration(
                    0.3, delay: 0, options: .CurveEaseInOut, animations: {
                    self.scroller.contentOffset = CGPoint(
                    x: self.scroller.bounds.size.width * CGFloat(sender.currentPage),
                    y: 0)
                    },
                    completion: nil)
    }
    
}


extension LandscapeViewController: UIScrollViewDelegate {
        func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let currentPage = Int((scrollView.contentOffset.x + width / 2) / width)
        pageController.currentPage = currentPage
        }
}
