//
//  ActivityController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/20/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class ActivityController: UIViewController {
    
    let locationManager = LocationManager.shared
    var seconds = 0
    var timer: Timer?
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    var activity: Activity?
    var currentCoordinate: CLLocationCoordinate2D?
    
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    let overLayControls: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 49/255, blue: 178/255, alpha: 0.65)
        return view
    }()
    
    let controlsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.text = "Choose an activity"
        label.textAlignment = .center
        return label
    }()
    
    let walkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "walk"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleWalkActivity), for: .touchUpInside)
        return button
    }()
    
    let runButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "run"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleRunActivity), for: .touchUpInside)
        return button
    }()
    
    let cycleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "bike"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleCycleActivity), for: .touchUpInside)
        return button
    }()
    
    let controlToolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.isHidden = true
        tb.barTintColor = .white
        tb.tintColor = mainColor
        tb.isTranslucent = true
        tb.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(handleStart))], animated: true)
        return tb
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00:00"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    let paceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    let distanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "DISTANCE"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    let durationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "DURATION"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    let paceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "PACE"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCancelButton()
        setupControls()
        configureLocationServices()
        mapView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func everySec() {
        seconds += 1
        updateDisplay()
    }
    
    fileprivate func updateDisplay() {
        let frmtDistance = FormatDisplay.distance(distance)
        let frmtTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = frmtDistance
        durationLabel.text = frmtTime
        paceLabel.text = formattedPace
    }
    
    fileprivate func configureLocationServices() {
        locationManager.delegate = self
        let status =  CLLocationManager.authorizationStatus()
        if status  == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            startLocationUpdates()
        }
    }
    
    private func startLocationUpdates() {
        mapView.showsUserLocation = true
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func zoomToLocation(with coordinate: CLLocationCoordinate2D){
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    
    fileprivate func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
    fileprivate func setupControls() {
        runButton.layer.cornerRadius = 25
        runButton.layer.masksToBounds = true
        walkButton.layer.cornerRadius = 25
        walkButton.layer.masksToBounds = true
        cycleButton.layer.cornerRadius = 25
        cycleButton.layer.masksToBounds = true
        
        let width = view.frame.width
        view.addSubview(mapView)
        view.addSubview(overLayControls)
        view.addSubview(controlToolbar)
        view.addSubview(durationLabel)
        view.addSubview(distanceLabel)
        view.addSubview(paceLabel)
        view.addSubview(durationTitleLabel)
        view.addSubview(distanceTitleLabel)
        view.addSubview(paceTitleLabel)
        
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        overLayControls.addSubview(controlsLabel)
        overLayControls.addSubview(runButton)
        overLayControls.addSubview(walkButton)
        overLayControls.addSubview(cycleButton)
        
        overLayControls.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width - 90, height: 120)
        
        overLayControls.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        controlsLabel.anchor(top: overLayControls.topAnchor, left: overLayControls.leftAnchor, bottom: nil, right: overLayControls.rightAnchor, paddingTop: 16, paddingLeft: 6, paddingBottom: 0, paddingRight: 6, width: 0, height: 20)
        
        runButton.anchor(top: controlsLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        runButton.centerXAnchor.constraint(equalTo: overLayControls.centerXAnchor).isActive = true
        
        walkButton.anchor(top: controlsLabel.bottomAnchor, left: nil, bottom: nil, right: runButton.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: (overLayControls.frame.width / 3) + 50, width: 50, height: 50)
        
        cycleButton.anchor(top: controlsLabel.bottomAnchor, left: runButton.rightAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: (overLayControls.frame.width / 3) + 50, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        controlToolbar.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 21, paddingRight: 0, width: 0, height: 80)
        
        durationLabel.anchor(top: controlToolbar.topAnchor, left: nil, bottom: nil, right: distanceLabel.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: (width / 3) - 8, height: 20)
        durationTitleLabel.anchor(top: durationLabel.bottomAnchor, left: nil, bottom: nil, right: distanceTitleLabel.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 3, width: (width / 3) - 8, height: 20)
        
        distanceLabel.anchor(top: controlToolbar.topAnchor, left: nil, bottom: nil, right:paceLabel.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width / 3, height: 20)
        distanceTitleLabel.anchor(top: distanceLabel.bottomAnchor, left: nil, bottom: nil, right: paceTitleLabel.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: (width / 3) - 8, height: 20)
        
        paceLabel.anchor(top: controlToolbar.topAnchor, left: nil, bottom: nil, right: controlToolbar.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: (width / 3) - 8, height: 20)
        paceTitleLabel.anchor(top: paceLabel.bottomAnchor, left: nil, bottom: nil, right: controlToolbar.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: (width / 3) - 8, height: 20)
    }
    
    @objc func handleCancel() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func handleRunActivity (){
        self.navigationItem.title = "Run"
        overLayControls.isHidden = true
        controlToolbar.isHidden = false
        durationLabel.isHidden = false
        distanceLabel.isHidden = false
        distanceTitleLabel.isHidden = false
        durationTitleLabel.isHidden = false
        paceLabel.isHidden = false
        paceTitleLabel.isHidden = false
    }
    
    @objc func handleWalkActivity (){
        self.navigationItem.title = "Walk"
        overLayControls.isHidden = true
        controlToolbar.isHidden = false
        durationLabel.isHidden = false
        distanceLabel.isHidden = false
        distanceTitleLabel.isHidden = false
        durationTitleLabel.isHidden = false
        paceLabel.isHidden = false
        paceTitleLabel.isHidden = false
    }
    
    @objc func handleCycleActivity (){
        self.navigationItem.title = "Cycle"
        overLayControls.isHidden = true
        controlToolbar.isHidden = false
        durationLabel.isHidden = false
        distanceLabel.isHidden = false
        distanceTitleLabel.isHidden = false
        durationTitleLabel.isHidden = false
        paceLabel.isHidden = false
        paceTitleLabel.isHidden = false
    }
    
    @objc func handleStart() {
        controlToolbar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(handleStop))], animated: true)
        self.startActivity()
    }
    
    @objc func handleStop() {
        let alert = UIAlertController(title: "Do you want to stop and save activity?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            self.controlToolbar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.handleStart))], animated: true)
            self.stopActivity()
            self.saveActivity()
            self.resetToStartDisplay()
            self.currentCoordinate = nil
            let detailController = ActivityDetailViewController()
            detailController.activity = self.activity
            self.navigationController?.pushViewController(detailController, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (_) in
            
            self.stopActivity()
            self.currentCoordinate = nil
            self.controlToolbar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.handleStart))], animated: true)
            self.resetToStartDisplay()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func startActivity() {
        mapView.removeOverlays(mapView.overlays)
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            self.everySec()
        })
        startLocationUpdates()
    }
    func  stopActivity() {
        self.timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func saveActivity() {
        if let uid = Auth.auth().currentUser?.uid{
        let newActivity = Activity(context: CoreDataStack.context)
        newActivity.distance = distance.value
        newActivity.duration = Int16(seconds)
        newActivity.timestamp = Date()
        newActivity.category = self.navigationItem.title
        newActivity.userid = uid
        newActivity.shared = false
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newActivity.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        activity = newActivity
        }
    }
    
    
    
    
    fileprivate func resetToStartDisplay() {
        self.controlToolbar.isHidden = true
        self.distanceLabel.isHidden = true
        self.distanceTitleLabel.isHidden = true
        self.durationLabel.isHidden = true
        self.distanceTitleLabel.isHidden = true
        self.paceLabel.isHidden = true
        self.paceTitleLabel.isHidden = true
        self.overLayControls.isHidden = false
        self.navigationItem.title = ""
        
    }
    
}

extension ActivityController:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        if currentCoordinate == nil {
            zoomToLocation(with: latestLocation.coordinate)
        }
        currentCoordinate = latestLocation.coordinate
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                zoomToLocation(with: newLocation.coordinate)
            }
            
            locationList.append(newLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startLocationUpdates()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let message = error.localizedDescription
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension ActivityController: MKMapViewDelegate {
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
