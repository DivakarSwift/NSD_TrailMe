//
//  StatsController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit

class StatsController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Stats"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        
        let alert = UIAlertController(title: "Alpha Release", message: "Sorry this feature is not available in this release.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

