//
//  FeedPostCell.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 10/8/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
protocol FeedPostCellDelegate {
    func didCommentOn(post: Post)
    func didLike(cell: FeedPostCell)
    func didHighFive(cell: FeedPostCell)
}

class FeedPostCell: UICollectionViewCell {
    
    var post: Post?{
        didSet{
            guard let postImageUrl = post?.mapImageUrl else { return }
            guard let userProfileImageUrl = post?.user.profileImageUrl else { return }
            postImageView.loadImage(from: postImageUrl)
            userProfileImageView.loadImage(from: userProfileImageUrl)
            userNameLabel.text = post?.user.username
            categoryLabel.text = post?.category
            distanceLabel.text = post?.distance
            let timeAgoDisplay = post?.creationDate.timeAgoDisplay()
            timeSinceLabel.text = timeAgoDisplay
            likeButton.setImage(post?.hasLiked == true ? UIImage(named: "liked")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    var delegate: FeedPostCellDelegate?
    
    let userProfileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .green
        return iv
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = mainColor
        return label
    }()

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()

    let postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()

    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()

    lazy var highFiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "high-five")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleHighFive), for: .touchUpInside)
        return button
    }()

    let timeSinceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(categoryLabel)
        addSubview(distanceLabel)
        addSubview(postImageView)

        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        userNameLabel.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: categoryLabel.leftAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        categoryLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 15)
        distanceLabel.anchor(top: categoryLabel.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 80, height: 15)
        postImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true

        setupActionButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, highFiveButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal

        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 60)

        addSubview(timeSinceLabel)
        timeSinceLabel.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 15)
    }
    

    @objc func handleLike() {
        delegate?.didLike(cell: self)
    }

    @objc func handleComment() {
        guard let post = post else { return }
         delegate?.didCommentOn(post: post)
      
    }

    @objc func handleHighFive() {
       delegate?.didHighFive(cell: self)
    }
}
