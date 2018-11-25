//
//  HistoryDetailController.swift
//  NSD_TrailMe
//
//  Created by Nathaniel Coleman on 11/22/18.
//  Copyright © 2018 Nathaniel Coleman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HistoryDetailController: UIViewController {
    var activity: Activity!
    
    let mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    let noteView: UITextView = {
        let tv = UITextView()
        return tv
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mapView.delegate = self
        setupUI()
        loadMap()
        loadNote()
    }
    
    fileprivate func loadNote() {
        guard let noteText = activity.note else { return }
        noteView.text = "NOTE:\n\(noteText)"
    }
    
    fileprivate func setupUI() {
        let height = view.frame.height
        view.addSubview(mapView)
        view.addSubview(noteView)
        view.addSubview(doneButton)
        
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 88, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: height / 4)
        
        noteView.anchor(top: mapView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
        
        
        doneButton.anchor(top: noteView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
    }
    
    
    @objc func handleDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func mapRegion() -> MKCoordinateRegion? {
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
    
    fileprivate func loadMap() {
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
    
    fileprivate func polyLine() -> MKPolyline {
        guard let locations = activity.locations else {
            return MKPolyline()
        }
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            let location = location as! Location
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
}

extension HistoryDetailController: MKMapViewDelegate {
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


