//
//  Post.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 10/9/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import Foundation

struct Post {
    let category: String
    let date: String
    let distance: String
    let duration: String
    let pace: String
    let note: String
    let mapImageUrl: String
    let creationDate: Date
    let user: User
    let postId: String

    var hasLiked = false
    var hasHighFive = false

    init(postId: String, user: User, dictionary: [String:Any]){
        self.category = dictionary["category"] as? String ?? ""
        self.date = dictionary["date"] as? String ?? ""
        self.distance = dictionary["distance"] as? String ?? ""
        self.duration = dictionary["duration"] as? String ?? ""
        self.mapImageUrl = dictionary["imageUrl"] as? String ?? ""
        self.pace = dictionary["pace"] as? String ?? ""
        self.note = dictionary["note"] as? String ?? ""
        self.user = user
        self.postId = postId
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970 / 1000.0)
    }
}
