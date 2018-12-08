//
//  WalkTableViewController.swift
//  TrailMe
//
//  Created by Nathaniel Coleman on 11/11/18.
//  Copyright © 2018 November 7th design. All rights reserved.
//

import UIKit
import CoreData

class WalkTableViewController: UITableViewController {

    let cellId = "cell"
    let sectionTitles = ["WEEKLY", "MONTHLY","YEAR–TO–DATE"]
    let rowTitles = ["Number of Walks", "Avg. Duration", "Avg. Distance"]
    var stats = [[0.0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0]]
    var walks = [Activity]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWalkAllActivities()
        loadWalkWeeklyActivities()
        loadWalkMonthlyActivities()
    }

    func loadWalkAllActivities() {
        walks.removeAll()
        let query = "Walk"
        let request = Activity.fetchRequest() as NSFetchRequest<Activity>
        request.predicate = NSPredicate(format: "category CONTAINS[c] %@", query)
        do {
            walks =  try CoreDataStack.context.fetch(request)
        } catch let error as NSError {print("Failed to fetch \(error), \(error.userInfo)")}

        if walks.count > 0 {
        let count = Double(walks.count)
        var temp = stats.remove(at: 2)
        _ = temp.remove(at: 0)
        temp.insert(count, at: 0)
        stats.insert(temp, at: 2)
        var times = [Int16]()
        var total: Int16 = 0
        var distance = 0.0
        var distances = [Double]()
        
        walks.forEach { (walk) in
            times.append(walk.duration)
            let formattedDistance = FormatDisplay.distance(walk.distance)
            distances.append(Double(formattedDistance.replacingOccurrences(of: " mi", with: ""))!)
        }
        times.forEach { (time) in
            total = total + time
        }
        let avgTime = total / Int16(times.count) / 60
        temp = stats.remove(at: 2)
        _ = temp.remove(at: 1)
        temp.insert(Double(avgTime), at: 1)
        stats.insert(temp, at: 2)

        distances.forEach { (miles) in
            distance += miles
        }
        let avgDistance = distance / Double(distances.count)
        temp = stats.remove(at: 2)
        _ = temp.remove(at: 2)
        temp.insert(avgDistance, at: 2)
        stats.insert(temp, at: 2)

            self.tableView.reloadData()}
    }

    func loadWalkWeeklyActivities() {
        walks.removeAll()
        let query = "Walk"
        let today = Date()
        guard let weekAgo = NSCalendar.current.date(byAdding: .day, value: -7, to: today) else { return }

        let request = Activity.fetchRequest() as NSFetchRequest<Activity>
        request.predicate = NSPredicate(format: " category CONTAINS[c] %@ AND timestamp < %@ AND timestamp > %@", query, today as CVarArg, weekAgo as CVarArg)
        do {
            walks =  try CoreDataStack.context.fetch(request)
        } catch let error as NSError {print("Failed to fetch \(error), \(error.userInfo)")}

        if walks.count > 0 {
        let count = walks.count
        var temp = stats.remove(at: 0)
        _ = temp.remove(at: 0)
        temp.insert(Double(count), at: 0)
        stats.insert(temp, at: 0)
        var times = [Int16]()
        var total: Int16 = 0
        var distance = 0.0
        var distances = [Double]()

        walks.forEach { (walk) in
            times.append(walk.duration)
            let formattedDistance = FormatDisplay.distance(walk.distance)
            distances.append(Double(formattedDistance.replacingOccurrences(of: " mi", with: ""))!)
        }
        times.forEach { (time) in
            total = total + time
        }
        let avgTime = total / Int16(times.count) / 60
        temp = stats.remove(at: 0)
        _ = temp.remove(at: 1)
        temp.insert(Double(avgTime), at: 1)
        stats.insert(temp, at: 0)

        distances.forEach { (miles) in
            distance += miles
        }
        let avgDistance = distance / Double(distances.count)
        temp = stats.remove(at: 0)
        _ = temp.remove(at: 2)
        temp.insert(avgDistance, at: 2)
        stats.insert(temp, at: 0)

        self.tableView.reloadData()
            }
        }


    func loadWalkMonthlyActivities() {
        walks.removeAll()
        let query = "Walk"
        let today = Date()
       guard let monthAgo = NSCalendar.current.date(byAdding: .month, value: -1, to: today) else { return }

        let request = Activity.fetchRequest() as NSFetchRequest<Activity>
        request.predicate = NSPredicate(format: " category CONTAINS[c] %@ AND timestamp < %@ AND timestamp > %@", query, today as CVarArg, monthAgo as CVarArg)
        do {
            walks =  try CoreDataStack.context.fetch(request)
        } catch let error as NSError {print("Failed to fetch \(error), \(error.userInfo)")}

        if walks.count > 0 {
        let count = walks.count
        var temp = stats.remove(at: 1)
        _ = temp.remove(at: 0)
        temp.insert(Double(count), at: 0)
        stats.insert(temp, at: 1)
        var times = [Int16]()
        var total: Int16 = 0
        var distance = 0.0
        var distances = [Double]()

        walks.forEach { (walk) in
            times.append(walk.duration)
            let formattedDistance = FormatDisplay.distance(walk.distance)
            distances.append(Double(formattedDistance.replacingOccurrences(of: " mi", with: ""))!)
        }
        times.forEach { (time) in
            total = total + time
        }
        let avgTime = total / Int16(times.count) / 60
        temp = stats.remove(at: 1)
        _ = temp.remove(at: 1)
        temp.insert(Double(avgTime), at: 1)
        stats.insert(temp, at: 1)



        distances.forEach { (miles) in
            distance += miles
        }
        let avgDistance = distance / Double(distances.count)
        temp = stats.remove(at: 1)
        _ = temp.remove(at: 2)
        temp.insert(avgDistance, at: 2)
        stats.insert(temp, at: 1)

            self.tableView.reloadData()}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        header.backgroundColor =  UIColor.rgb(red: 239, green: 239, blue: 244)
        let label = UILabel()
        label.frame = CGRect(x: 5, y: 5, width: header.frame.width - 10, height: header.frame.height - 10)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkText
        label.text = self.sectionTitles[section]
        header.addSubview(label)

        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return rowTitles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.textColor = mainColor
        cell.detailTextLabel?.textColor = mainColor
        cell.textLabel?.text = rowTitles[indexPath.row]
        switch indexPath.row {
        case 0:
             let value = Int(stats[indexPath.section][indexPath.row])
            cell.detailTextLabel?.text = "\(value)"
        case 1:
            cell.detailTextLabel?.text = "\(stats[indexPath.section][indexPath.row]) min"
        case 2:
            cell.detailTextLabel?.text = "\(stats[indexPath.section][indexPath.row]) mi"
        default:
            break
        }
        return cell
    }

}
