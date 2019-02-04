//
//  MapViewController.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/01/31.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit
import MapKit

import CoreLocation
import SnapKit

final class MapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var latitudeValue: UILabel!
    @IBOutlet weak private var longitudeValue: UILabel!
    
    var locationManager: CLLocationManager!
    
    var promoteView: PromoteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        // - Location Manager
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 最高精度

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.distanceFilter = Map.distanceFilter
            locationManager.startUpdatingLocation()
        }
        
        // - Map View
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
        mapView.userTrackingMode = .followWithHeading
        
        setRegion(coordinate: mapView.userLocation.coordinate)
        
        // - Promote View
        promoteView = PromoteView.loadFromNib()
        promoteView.isHidden = true
        view.addSubview(promoteView)
        promoteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(
            latitudeDelta: Map.latitudeDelta,
            longitudeDelta: Map.longitudeDelta
        )
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // called when user authorization is updated
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            promoteView.isHidden = false
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // called when user location is updated
        if let coordinate = locations.last?.coordinate {
            latitudeValue.text = (round(coordinate.latitude) / 10).description
            longitudeValue.text = (round(coordinate.longitude) / 10).description
            setRegion(coordinate: coordinate)
            
            // remove pins & put a pin
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = L10n.Annotation.title
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
            
            // draw circle
            let circle = MKCircle(center: coordinate, radius: Map.circleRadius)
            mapView.addOverlay(circle)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleView = MKCircleRenderer(overlay: overlay)
        circleView.fillColor = .red
        circleView.alpha = 0.9
        return circleView
    }
}
