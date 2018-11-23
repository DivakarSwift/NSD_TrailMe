//
//  Comment.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/5/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import Foundation
struct Comment {
    let text: String
    let uid: String
    let user: User

    init(user: User, dictionary: [String:Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
    }
}
