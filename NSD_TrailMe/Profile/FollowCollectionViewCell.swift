//
//  FollowCollectionViewCell.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/5/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit

class FollowCollectionViewCell: UICollectionViewCell {
    @IBOutlet var profileImageView: CustomImageView!

    var user: User? {
        didSet{
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(from: profileImageUrl)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

}
