//
//  EditProfileTableViewHeader.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 9/30/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit

protocol EditProfileHeaderDelegate {
    func didEditProfile() 
}

class EditProfileTableViewHeader: UITableViewCell {
    var delegate : EditProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            getProfileImage()
        }
    }
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    lazy var editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change photo", for: .normal)
        button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        addSubview(editButton)
        
        profileImage.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImage.layer.cornerRadius = 100 / 2
        profileImage.clipsToBounds = true
        profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        editButton.anchor(top: profileImage.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 20)
        editButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    @objc func handleEditProfile() {
        delegate?.didEditProfile()
    }
    
    func getProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: profileImageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImage.image = image
                }
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
