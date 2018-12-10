//
//  AwardCellTableViewCell.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 12/9/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit

class AwardCellTableViewCell: UITableViewCell {

    @IBOutlet weak var awardImageView: UIImageView!
    @IBOutlet weak var awardLabel: UILabel!
    
    var award: Award?{
        didSet{
            guard let awardImage = award?.awardImage else { return }
            guard let awardDesc = award?.awardDescription else { return }
            awardImageView.image = UIImage(named: awardImage)
            awardLabel.text = awardDesc
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
