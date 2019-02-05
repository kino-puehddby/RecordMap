//
//  MapViewController.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/01/31.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit
import MapKit

import RxSwift
import RxCocoa
import CoreLocation
import SnapKit
import FloatingPanel

final class MapViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!
    @IBOutlet weak private var dropPinButton: UIButton!
    
    lazy var floatingPanelController: FloatingPanelController = {preconditionFailure()}()
    lazy var locationManager: CLLocationManager = {preconditionFailure()}()
    lazy var promoteView: PromoteView = {preconditionFailure()}()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    func setup() {
        // - Location Manager
        locationManager = CLLocationManager()
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
        
        // Floating Panel
        floatingPanelController = FloatingPanelController()
        floatingPanelController.surfaceView.layer.cornerRadius = 12
        floatingPanelController.surfaceView.layer.masksToBounds = true
        floatingPanelController.surfaceView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        floatingPanelController.delegate = self
        let semiModalVC = StoryboardScene.SemiModal.initialScene.instantiate()
        floatingPanelController.set(contentViewController: semiModalVC)
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    func bind() {
        dropPinButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.perform(segue: StoryboardSegue.Main.presentModal)
            })
            .disposed(by: disposeBag)
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        // ajust point to 'coordinate'
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
            setRegion(coordinate: coordinate)
            
            // remove pins & drop a pin
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

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        // TODO: targetPositionが変わった時の処理
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        let floatingPanelLayout = MapViewFloatingPanelLayout()
        return floatingPanelLayout
    }
}

class MapViewFloatingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full:
            return Map.FloatingPanel.fullPosition
        case .tip:
            return Map.FloatingPanel.tipPosition
        default:
            return nil
        }
    }
    
    func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Map.FloatingPanel.sideSpace),
            surfaceView.widthAnchor.constraint(equalToConstant: Map.FloatingPanel.width)
        ]
    }
}
