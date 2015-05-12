//
//  searchResponseCell.swift
//  CraigSearch
//
//  Created by Calvin Nisbet on 2015-05-05.
//  Copyright (c) 2015 Calvin Nisbet. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var downloadTask: NSURLSessionDownloadTask?

    override func awakeFromNib() {
        
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zeroRect)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

func configureForSearchResult(searchResult: SearchResult) {
    nameLabel.text = searchResult.name
    if searchResult.artistName.isEmpty {
    artistNameLabel.text = "Unknown"
} else {
    artistNameLabel.text = String(format: "%@ (%@)",
    searchResult.artistName, searchResult.kindForDisplay())
    
    }
    artworkImageView.image = UIImage(named: "Placeholder")
    if let url = NSURL(string: searchResult.artworkURL60) {
        downloadTask = artworkImageView.loadImageWithURL(url)
    }
}

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        
        nameLabel.text = nil
        artistNameLabel.text = nil
        artworkImageView.image = nil
    }   
    


}
