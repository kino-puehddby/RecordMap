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
    
    var postDismissionAction: (() -> Void)?
    
    // - Rx
    private let disposeBag = DisposeBag()
    private let dismiss = PublishSubject<Void>()
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
            .do(onNext: { [unowned self] in
                if self.textInput.value == "" { return }
                let locationData = LocationModel(
                    name: self.textInput.value,
                    address: self.address.value,
                    latitude: self.latitude.value,
                    longitude: self.longitude.value
                )
                self.realm.customAdd(locationData)
            })
            .drive(dismiss)
            .disposed(by: disposeBag)
        
        dismiss
            .subscribe(onNext: {
                self.dismiss(animated: true, completion: { [unowned self] in
                    self.postDismissionAction?() // call back
                })
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
