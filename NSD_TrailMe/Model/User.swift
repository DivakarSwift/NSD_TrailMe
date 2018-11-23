//
//  User.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 10/9/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import Foundation

struct User {
    let firstName: String
    let lastName: String
    let profileImageUrl: String
    let username: String
    let email: String
    let isPublic: Bool
    let uid: String
    init(uid: String, dictionary: [String:Any]) {
        self.uid = uid
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["userName"] as? String ?? ""
        self.isPublic = dictionary["isPublic"] as? Bool ?? false
    }
}
