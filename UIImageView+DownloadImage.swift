//
//  UIImageView+DownloadImage.swift
//  CraigSearch
//
//  Created by Calvin Nisbet on 2015-05-10.
//  Copyright (c) 2015 Calvin Nisbet. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageWithURL(url: NSURL) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: { [weak self] url, response, error in
            if error == nil && url != nil {
                if let data = NSData(contentsOfURL: url) {
                if let image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue()) {
                if let strongSelf = self {
                strongSelf.image = image
                }
                }
                }
            }
            }
            })
        // 5
        downloadTask.resume()
        return downloadTask
    }
}