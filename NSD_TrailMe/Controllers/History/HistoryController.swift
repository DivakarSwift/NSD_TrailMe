//
//  HistoryController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import Firebase


class HistoryController: UITableViewController {
    
    let cellId = "cellId"
    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "History"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.register(HistoryCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getActivities()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryCell
        let formattedDate = FormatDisplay.date(activities[indexPath.row].timestamp)
        let timeString = activities[indexPath.row].timestamp?.getTimeString()
        cell.categoryLabel.text = activities[indexPath.row].category
        cell.dateLabel.text = formattedDate
        cell.timeLabel.text = timeString
        if activities[indexPath.row].shared == true {
            cell.sharedLabel.text = "Shared"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = HistoryDetailController()
        destination.activity = activities[indexPath.row]
        present(destination, animated: true, completion: nil)
    }
    
    fileprivate func getActivities() {
        if let uid = Auth.auth().currentUser?.uid {
        let context = CoreDataStack.context
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "userid = %@", uid)
        do {
            activities = try context.fetch(fetchRequest)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    }
    
}

extension HistoryController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
