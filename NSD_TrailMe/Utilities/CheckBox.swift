//
//  CheckBox.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    convenience init() {
        self.init(frame: .zero)
        let origSelected = UIImage(named: "selected")
        let origSelectedWhite = origSelected?.withRenderingMode(.alwaysTemplate)
        let origUnselected = UIImage(named: "unselected")
        let origUnselectedWhite = origUnselected?.withRenderingMode(.alwaysTemplate)
        self.setImage(origSelectedWhite, for: .selected)
        self.setImage(origUnselectedWhite, for: .normal)
        self.tintColor = .black
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        self.isSelected = !self.isSelected
    }
}
