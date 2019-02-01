//
//  ViewController.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/01/31.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class ViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var latitudeValue: UILabel!
    @IBOutlet weak private var longitudeValue: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 最高精度

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation() // 認証を要求
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 初回起動時に位置情報取得の許可を取る
        switch status {
        case .notDetermined: // 設定されてない
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied: // 拒否されている
            break
        case .authorizedAlways, .authorizedWhenInUse: // 許可されている
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 位置情報を更新するたびに呼ばれる
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            latitudeValue.text = "".appendingFormat("%.4f", coordinate.latitude)
            longitudeValue.text = "".appendingFormat("%.4f", coordinate.longitude)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            // ピン表示
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "I'm here"
            annotation.subtitle = "foo"
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
}
