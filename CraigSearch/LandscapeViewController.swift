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
    
    
   
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
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
        
        for (index, searchResult) in enumerate(searchResults) {
            
            let button = UIButton.buttonWithType(.Custom) as! UIButton
            button.tag = 2000 + index
            button.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: .TouchUpInside)
            button.setBackgroundImage(UIImage(named: "LandscapeButton"), forState: .Normal)
            
            button.frame = CGRect(x: x + paddingHorz, y: marginY + CGFloat(row)*itemHeight + paddingVert, width: buttonWidth, height: buttonHeight)
            
//            button.tag = 2000 + index
//            button.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: .TouchUpInside)
//            
            scroller.addSubview(button)
            
            downloadImageForSearchResult(searchResult, andPlaceOnButton: button)
            
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
            switch search.state {
            case .NotSearchedYet:
                break
            case .Loading:
                showSpinner()
            case .NoResults:
                showNothingFoundLabel()
            case .Results(let list):
                tileButtons(list)
            }
        }
    }
    
    
    private func showSpinner() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.center = CGPoint(x: CGRectGetMidX(scroller.bounds) + 0.5, y: CGRectGetMidY(scroller.bounds) + 5)
        spinner.tag = 100
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    
    private func showNothingFoundLabel() {
        let newLabel = UILabel(frame: CGRect.zeroRect)
        newLabel.text = "Nothing Found"
        newLabel.backgroundColor = UIColor.clearColor()
        newLabel.textColor = UIColor.whiteColor()
        
        newLabel.sizeToFit()
        
        var rectangle = newLabel.frame
        rectangle.size.width = ceil(rectangle.size.width/2) * 2
        rectangle.size.height = ceil(rectangle.size.height/2) * 2
        
        newLabel.frame = rectangle
        newLabel.center = CGPoint(x: CGRectGetMidX(scroller.bounds), y: CGRectGetMidY(scroller.bounds))
        view.addSubview(newLabel)
    }
    
    
    func buttonPressed(sender: UIButton) {
        performSegueWithIdentifier("ShowDetail", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            switch search.state {
            case .Results(let list):
                let popupViewController = segue.destinationViewController as! DetailViewController
                let searchResult = list[sender!.tag - 2000]
                popupViewController.searchResult = searchResult
            default:
                break
            }
        }
    }
    
    
    func resultsReceived() {
        hideSpinner()
        switch search.state {
        case .NotSearchedYet, .Loading:
            break
        case .NoResults:
            showNothingFoundLabel()
        case .Results(let list):
            tileButtons(list)
        }
    }
    
    private func hideSpinner() {
        view.viewWithTag(1000)?.removeFromSuperview()
    }
    
    
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
