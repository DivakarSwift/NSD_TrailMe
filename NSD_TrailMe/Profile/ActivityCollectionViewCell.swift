//
//  ActivityCollectionViewCell.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/6/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {
    @IBOutlet var activityMapImageView: CustomImageView!

    var post: Post? {
        didSet{
            guard let imageUrl = post?.mapImageUrl else { return }
            activityMapImageView.loadImage(from: imageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
