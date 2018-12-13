//
//  ActivityDetailViewController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/22/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreData

class ActivityDetailViewController: UIViewController {
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    let activityIndicator = UIActivityIndicatorView()
    var activity: Activity!
    var activityMapImage: UIImage?
    static var note: String?
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "CATEGORY"
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "DATE"
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let distanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "DISTANCE"
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let durationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "DURATION"
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    let paceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    let paceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "PACE"
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return label
    }()
    
    let staticMapImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let noteTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = backColor
        tv.isEditable = false
        tv.font = UIFont.boldSystemFont(ofSize: 17)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        navigationItem.title = "Details"
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
        let noteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleAddNote))
        navigationItem.rightBarButtonItems = [shareButton, noteButton]
        mapView.delegate = self
        setupViews()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayNote()
    }
    
    @objc func handleShare() {
        takeSnapShot()
    }
    @objc func handleAddNote() {
        let noteController = NoteController()
        NoteController.noteOut = ActivityDetailViewController.note
        navigationController?.pushViewController(noteController, animated: true)
    }
    
    fileprivate func displayNote () {
        guard let noteText = ActivityDetailViewController.note, noteText.count > 0  else{
            noteTextView.text = "No note for this activity"
            return }

            noteTextView.text = noteText
            activity.note = noteTextView.text
            CoreDataStack.saveContext()
    }
    fileprivate func saveToDatabase(with imageUrl: String){
        UserDefaults.standard.set(true, forKey: "hasPosts")
        guard let date = dateLabel.text else { return }
        guard let category = categoryLabel.text  else { return }
        guard let distance = distanceLabel.text else { return }
        guard let duration = durationLabel.text else { return }
        guard let pace = paceLabel.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let usernameReference = Database.database().reference().child("users").child(uid)
        usernameReference.observe(.value, with: { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else { return }
            let username = value["userName"] as? String ?? ""
            let userPostReference = Database.database().reference().child("posts").child(uid + "-" + username)
            let reference = userPostReference.childByAutoId()
            if let postNote = ActivityDetailViewController.note {
                let values = ["imageUrl" : imageUrl, "category":category, "date":date, "duration":duration, "distance":distance, "pace":pace,"note":postNote ,"creationDate":ServerValue.timestamp()] as [String : Any]
                reference.updateChildValues(values) { (error, ref) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                }
            } else {
                let values = ["imageUrl" : imageUrl, "category":category, "date":date, "duration":duration, "distance":distance, "pace":pace, "creationDate":ServerValue.timestamp()] as [String : Any]
                reference.updateChildValues(values) { (error, ref) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
      
    }
    
    fileprivate func setupViews() {
        let height = view.frame.height
        
        
        view.addSubview(mapView)
        view.addSubview(categoryLabel)
        view.addSubview(categoryTitleLabel)
        view.addSubview(dateLabel)
        view.addSubview(dateTitleLabel)
        view.addSubview(distanceLabel)
        view.addSubview(distanceTitleLabel)
        view.addSubview(durationLabel)
        view.addSubview(durationTitleLabel)
        view.addSubview(paceLabel)
        view.addSubview(paceTitleLabel)
        view.addSubview(activityIndicator)
        view.addSubview(staticMapImageView)
        view.addSubview(noteTextView)
       
        
        activityIndicator.color = mainColor
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 92, paddingLeft: 4, paddingBottom: 0, paddingRight: 4, width: 0, height: height / 4)
        
        categoryLabel.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        categoryTitleLabel.anchor(top: categoryLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        
        dateLabel.anchor(top: categoryTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 20)
        dateTitleLabel.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        
        distanceLabel.anchor(top: dateTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 20)
        distanceTitleLabel.anchor(top: distanceLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        
        durationLabel.anchor(top: distanceTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 20)
        durationTitleLabel.anchor(top: durationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        
        paceLabel.anchor(top: durationTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 20)
        paceTitleLabel.anchor(top: paceLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        
        activityIndicator.anchor(top: paceTitleLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        noteTextView.anchor(top: activityIndicator.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 100)
        
        staticMapImageView.anchor(top: noteTextView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 100)
        staticMapImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    private func configureView() {
        let distance = Measurement(value: activity.distance, unit: UnitLength.meters)
        let seconds = Int(activity.duration)
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedDate = FormatDisplay.date(activity.timestamp)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        categoryLabel.text = activity.category
        distanceLabel.text = formattedDistance
        dateLabel.text = formattedDate
        durationLabel.text = formattedTime
        paceLabel.text = formattedPace
        
        loadMap()
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
        guard
            let locations = activity.locations,
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func loadMap() {
        guard
            let locations = activity.locations,
            locations.count > 0,
            let region = mapRegion()
            else {
                let alert = UIAlertController(title: "Error",
                                              message: "Sorry, this run has no locations saved",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyLine())
    }
    
    private func polyLine() -> MKPolyline {
        guard let locations = activity.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    fileprivate func takeSnapShot() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        activity.shared = true
        CoreDataStack.saveContext()
        
        if activityIndicator.isAnimating == true {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
        else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        let mapSnapShotOptions = MKMapSnapshotter.Options()
        guard let region = mapRegion() else { return }
        mapSnapShotOptions.region = region
        mapSnapShotOptions.scale = UIScreen.main.scale
        mapSnapShotOptions.size = CGSize(width: 200, height: 100)
        mapSnapShotOptions.showsPointsOfInterest = false
        mapSnapShotOptions.showsBuildings = false
        
        let snapShotter = MKMapSnapshotter(options: mapSnapShotOptions)
        
        snapShotter.start { (snapShot, err) in
            guard let snapshot = snapShot else { return }
            
            //self.activityMapImage = self.drawLineOnImage(snapshot: snapshot)
            let image = self.drawLineOnImage(snapshot: snapshot)
            let filename = NSUUID().uuidString
            guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
            // store image in Firebase Storage
            Storage.storage().reference().child("map_images").child(filename).putData(uploadData, metadata: nil) { (metaData, error) in
                if let err = error {
                    print("Failed to upload post image: \(err.localizedDescription)")
                    
                    return
                }
                Storage.storage().reference().child("map_images").child(filename).downloadURL(completion: { (url, err) in
                    if let error = err {
                        print("Failed to get url:  \(error.localizedDescription)")
                        return
                    } else {
                        guard let imageUrl = url?.absoluteString else { return }
                        // store post To Firebase Database
                        self.saveToDatabase(with: imageUrl)
                        
                        let mainTabBarController = TabBarController()
                        mainTabBarController.selectedIndex = 0
                        mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                        NotificationCenter.default.post(name: ActivityDetailViewController.updateFeedNotificationName, object: nil)
                    }
                })
            }
            
        }
        
    }
    
    fileprivate func drawLineOnImage(snapshot: MKMapSnapshotter.Snapshot) -> UIImage {
        let locations = activity.locations
        let coords: [CLLocationCoordinate2D] = (locations?.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            })!
        let image = snapshot.image
        UIGraphicsBeginImageContextWithOptions(self.staticMapImageView.frame.size, true, 0)
        image.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.move(to: snapshot.point(for: coords[0]))
        for i in 0...coords.count - 1 {
            context?.addLine(to: snapshot.point(for: coords[i]))
            context?.move(to: snapshot.point(for: coords[i]))
        }
        context?.strokePath()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
}
extension ActivityDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .black
        renderer.lineWidth = 3
        return renderer
    }
}
