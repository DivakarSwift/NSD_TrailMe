//
//  AwardsTableViewController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 12/9/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit

class AwardsTableViewController: UITableViewController {

    var awards = [Award]()
    
    let cellId = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AwardCellTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)

        let firstAward = Award(awardImage: "award0", awardDescription: "Your first Activity Award")
        awards.append(firstAward)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return awards.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AwardCellTableViewCell
        cell.award = awards[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

}
