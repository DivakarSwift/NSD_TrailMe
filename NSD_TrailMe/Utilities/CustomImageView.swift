//
//  CustomImageView.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/22/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()
class CustomImageView: UIImageView {
    var lastUrlToLoadImage: String?
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        lastUrlToLoadImage = urlString
        self.image = nil
        if let cachedImage = imageCache[urlString]  {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let error = err {
                print("Failed to download image: \(error)")
                return
            }
            if url.absoluteString != self.lastUrlToLoadImage { return }
            guard let data = data else { return }
            let image = UIImage(data: data)
            imageCache[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
}
