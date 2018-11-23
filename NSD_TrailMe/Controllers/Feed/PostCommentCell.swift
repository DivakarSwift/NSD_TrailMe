//
//  PostCommentCell.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/5/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit

class PostCommentCell: UICollectionViewCell {

    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            let attributedText = NSMutableAttributedString(string: comment.user.username , attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            textTextView.attributedText = attributedText
            profileImageView.loadImage(from: comment.user.profileImageUrl)
        }
    }
    let textTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        return textView
    }()
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .blue
        return iv
    }()

    let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    fileprivate func setupViews() {
        addSubview(textTextView)
        addSubview(profileImageView)
        addSubview(seperator)

        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2

        textTextView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 14, paddingBottom: 0, paddingRight: 14, width: 0, height: 0)

       seperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 60, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
