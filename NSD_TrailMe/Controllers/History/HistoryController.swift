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


class HistoryController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let cellId = "cellId"

    lazy var fetchedResultsController: NSFetchedResultsController<Activity> = {
        let context = CoreDataStack.context
        let uid = Auth.auth().currentUser?.uid
        let fetchRequest = NSFetchRequest<Activity>(entityName: "Activity")
        fetchRequest.predicate = NSPredicate(format: "userid = %@", uid!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
           tableView.insertRows(at: [newIndexPath!], with:.none)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "History"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.register(HistoryCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do{
            try fetchedResultsController.performFetch()
        }catch let err {
            print(err)
        }
        tableView.reloadData()
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            if count == 0 {
                self.tableView.setEmptyDisplay("Your activity history is empty. Go track an activity!")
                return count
            }
            self.tableView.restoreView()
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryCell
        let activity = fetchedResultsController.object(at: indexPath)
        let formattedDate = FormatDisplay.date(activity.timestamp)
        let timeString = activity.timestamp?.getTimeString()
        cell.categoryLabel.text = activity.category
        cell.dateLabel.text = formattedDate
        cell.timeLabel.text = timeString
        if activity.shared == true {
            cell.sharedLabel.text = "Shared"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = HistoryDetailController()
        destination.activity = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(destination, animated: true)
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

extension UITableView {
    func setEmptyDisplay(_ text: String){
        let message = UILabel(frame: CGRect(x: 0, y: 0, width:self.bounds.size.width , height: self.bounds.size.height))
        message.text = text
        message.textColor = mainColor
        message.numberOfLines = 0
        message.textAlignment = .center
        message.sizeToFit()
        
        self.backgroundView = message
        self.separatorStyle = .none
    }
    
    func restoreView()  {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
