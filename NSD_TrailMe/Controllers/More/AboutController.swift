//
//  AboutController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
let header: UILabel = {
    let label = UILabel()
    label.textColor = mainColor
    label.font = UIFont.boldSystemFont(ofSize: 27)
    label.text = "About November 7th design"
    return label
}()
let displayTextView: UITextView = {
    let tv = UITextView()
    tv.textColor = .black
    tv.isEditable = false
    tv.font = UIFont.boldSystemFont(ofSize: 17)
    tv.text = "November 7th design is a development agency dedicated to creating useful and beautiful mobile applications. We believe in being creative and expressing this in all our projects. "
    return tv
}()

class AboutController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "About Us"
        
        view.addSubview(header)
        view.addSubview(displayTextView)
        
        header.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 30)
        
        displayTextView.anchor(top: header.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 300)
    }
}
