//
//  MoreController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import Firebase



class MoreController: UITableViewController {
    let items = ["Profile", "Stats", "About"]
    let icons = ["user", "stopwatch", "info"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLogout()
        
        view.backgroundColor = backColor
        title = "More"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.register(MoreTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoreTableViewCell
        cell.cellTitleLabel.textColor = mainColor
        cell.cellTitleLabel.text = items[indexPath.row]
        cell.cellImageView.image = UIImage(named: icons[indexPath.row])
        cell.tintColor = mainColor
        cell.accessoryType = .disclosureIndicator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: "Alternate", bundle: nil)
            if let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as?
                ProfileViewController
            {
                navigationController?.pushViewController(profileViewController, animated: true)
            }
        case 1:
            let storyboard = UIStoryboard(name: "Statistic", bundle: nil)
            if let statsPageViewController = storyboard.instantiateViewController(withIdentifier: "StatsPageViewController") as?
                StatsRootPageViewController
            {
                navigationController?.pushViewController(statsPageViewController, animated: true)
            }
        case 2:
            let destination = AboutController()
            navigationController?.pushViewController(destination, animated: true)
            
        default:
            break
        }
    }
    
    fileprivate func setupLogout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(handleLogout))
    }
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                
                let signInController = LoginViewController()
                let navController = UINavigationController(rootViewController: signInController)
                self.present(navController, animated: true, completion: nil)
            } catch let signOutErr {
                print(signOutErr.localizedDescription)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
