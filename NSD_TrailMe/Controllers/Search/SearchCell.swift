//
//  SearchCell.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 10/9/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
import Firebase

class SearchCell: UICollectionViewCell {
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            guard let uid = user?.uid else { return }
            guard let username = user?.username else { return }
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(from: profileImageUrl)
            getActivityCount(uid: uid, username: username)
        }
    }


    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = mainColor
        return label
    }()

    let userPostsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()


    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func getActivityCount(uid: String, username: String) {
        Database.database().reference().child("posts").child(uid + "-" + username).observeSingleEvent(of: .value, with: { (snapshot) in
            let count = snapshot.childrenCount
            if count == 1 {
                self.userPostsLabel.text = "\(count) post"
            } else {
                self.userPostsLabel.text = "\(count) posts"
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    fileprivate func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(userPostsLabel)
        addSubview(seperator)

        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50 / 2

        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)

        userPostsLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 4, width: 0, height: 20)
        seperator.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 60, paddingBottom: 3, paddingRight: 0, width: 0, height: 0.5)
    }
}
