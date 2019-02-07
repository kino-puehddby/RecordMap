//
//  ModalViewController.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/02/05.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit
import CoreLocation

import RxSwift
import RxCocoa
import RealmSwift

final class ModalViewController: UIViewController {

    @IBOutlet weak private var modalView: UIView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var desideButton: UIButton!
    
    private let realm = try! Realm()
    
    // - Rx
    private let disposeBag = DisposeBag()
    private let textInput = BehaviorRelay<String>(value: "")
    let latitude = BehaviorRelay<Double>(value: 0)
    let longitude = BehaviorRelay<Double>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    func setup() {
        modalView.layer.cornerRadius = 12
    }
    
    func bind() {
        closeButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .bind(to: textInput)
            .disposed(by: disposeBag)
        
        desideButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                let locationData = LocationData()
                locationData.name = self.textInput.value
                locationData.address = self.createAddress(
                    latitude: self.latitude.value,
                    longitude: self.longitude.value
                )
                locationData.location?.latitude = self.latitude.value
                locationData.location?.longitude = self.longitude.value
                self.realm.customAdd(locationData)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func createAddress(latitude: Double, longitude: Double) -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let output: String = {
            var address = ""
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil,
                    let placemark = placemarks?.last else { return }
                address += placemark.country ?? ""
                address += placemark.administrativeArea ?? ""
                address += placemark.locality ?? ""
            }
            return address
        }()
        return output
    }
}

extension ModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
