//
//  DetailViewController.swift
//  CraigSearch
//
//  Created by Calvin Nisbet on 2015-05-11.
//  Copyright (c) 2015 Calvin Nisbet. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!

    var searchResult: SearchResult!
    var downloadTask: NSURLSessionDownloadTask?
   
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    
    deinit {
        println("deinit \(self)")
        downloadTask?.cancel()
    }
    
    enum AnimationStyle {
        case Slide
        case Fade
    }
    var dismissAnimationStyle = AnimationStyle.Fade
    
    @IBAction func openInStore() {
        if let url = NSURL(string: searchResult.storeURL) {
        UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        view.backgroundColor = UIColor.clearColor() 
        
        
        popupView.layer.cornerRadius = 10
    
        let gestureRec = UITapGestureRecognizer(target: self, action: Selector("close"))
        gestureRec.cancelsTouchesInView = false
        gestureRec.delegate = self
        view.addGestureRecognizer(gestureRec)
        
        if searchResult != nil {
            updateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func updateUI() {
        
        nameLabel.text = searchResult.name
        
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        kindLabel.text = searchResult.kindForDisplay()
        genreLabel.text = searchResult.genre
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencyCode = searchResult.currency
        var priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
        } else if let text = formatter.stringFromNumber(searchResult.price) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, forState: .Normal)
    
        if let url = NSURL(string: searchResult.artworkURL100) {
            downloadTask = artworkImageView.loadImageWithURL(url)
        }
    }
    
    
    
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
        dismissAnimationStyle = .Slide
    }
}
    
    extension DetailViewController: UIViewControllerTransitioningDelegate {
        
        func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
            
            return DimmedPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        
        
            func animationControllerForDismissedController(
                dismissed: UIViewController)
                -> UIViewControllerAnimatedTransitioning? {
                switch dismissAnimationStyle {
            case .Slide:
                return SlideOutAnimation()
            case .Fade:
                return FadeOutAnimationController()
                }
            }
        
        
        func animationControllerForPresentedController(
            presented: UIViewController,
            presentingController presenting: UIViewController,
            sourceController source: UIViewController)
            -> UIViewControllerAnimatedTransitioning? {
            return BounceAnimateController()
        }
    }




extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer,
    shouldReceiveTouch touch: UITouch) -> Bool {
    return (touch.view === view)
    }
}