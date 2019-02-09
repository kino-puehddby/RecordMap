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
        
    weak var delegate: MapViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    private let dismiss = PublishSubject<Void>()
    private let textInput = BehaviorRelay<String>(value: "")
    let latitude = BehaviorRelay<Double>(value: 0)
    let longitude = BehaviorRelay<Double>(value: 0)
    let address = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: モーダルの繊維アニメーションをもっとかっこよくしたい
        
        setup()
        bind()
    }
    
    func setup() {
        modalView.layer.cornerRadius = 12
        textField.placeholder = L10n.Register.TextField.placeholder
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
                let realm = try! Realm()
                realm.customAdd(locationData)
            })
            .drive(dismiss)
            .disposed(by: disposeBag)
        
        dismiss
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: { [weak self] in
                    // reflect changes on TableView
                    self?.delegate?.onNextAdded()
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
