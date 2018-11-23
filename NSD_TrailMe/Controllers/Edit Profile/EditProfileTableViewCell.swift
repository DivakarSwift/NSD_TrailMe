//
//  EditProfileTableViewCell.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 9/30/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    let cellLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let valueTextField: UITextField = {
        let tf = UITextField()
        tf.clearButtonMode = .always
        return tf
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellLabel)
        addSubview(valueTextField)
        cellLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 100, height: 20)
        valueTextField.anchor(top: topAnchor, left: cellLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 16, width: 0, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
