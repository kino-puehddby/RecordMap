//
//  RegisterViewController.swift
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

final class RegisterViewController: UIViewController {

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
    let address = BehaviorRelay<String>(value: "")
    
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
                print("latitude = \(self.latitude.value)")
                print("longitude = \(self.longitude.value)")
                let locationData = LocationData()
                locationData.name = self.textInput.value
                locationData.address = self.address.value
                locationData.location?.latitude = self.latitude.value
                locationData.location?.longitude = self.longitude.value
                self.realm.customAdd(locationData)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
