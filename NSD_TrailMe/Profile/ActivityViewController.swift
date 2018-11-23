//
//  ActivityViewController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/6/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit


class ActivityViewController: UIViewController {
    @IBOutlet var distanceValueLabel: UILabel!
    @IBOutlet var durationValueLabel: UILabel!
    @IBOutlet var mapImageView: CustomImageView!
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            title = "\(post.category) – \(post.date)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedPost = post else { return }
       setupViews(with: selectedPost)
    }

    fileprivate func setupViews(with post: Post) {
        distanceValueLabel.text = post.distance
        durationValueLabel.text = post.duration
        mapImageView.loadImage(from: post.mapImageUrl)
    }


}
