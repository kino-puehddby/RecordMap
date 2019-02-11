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
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var desideButton: UIButton!
    
    weak var delegate: MapViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    private let dismiss = PublishSubject<Void>()
    private let textInput = BehaviorRelay<String>(value: "")
    let update = PublishSubject<Void>()
    let latitude = BehaviorRelay<Double>(value: 0)
    let longitude = BehaviorRelay<Double>(value: 0)
    let address = BehaviorRelay<String>(value: "")
    let selectedIndex = BehaviorRelay<Int?>(value: nil)
    
    var registerMode: RegisterMode = .add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: モーダルの繊維アニメーションをもっとかっこよくしたい
        setup()
        bind()
    }
    
    func setup() {
        modalView.layer.cornerRadius = 12
        textField.placeholder = L10n.Register.placeholder
        
        switch registerMode {
        case .add:
            nameLabel.text = L10n.Register.add
        case .edit:
            guard let index = selectedIndex.value else { return }
            let data = LocationModel.read()[index]
            textField.text = data.name
            nameLabel.text = L10n.Register.edit
        }
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
                self.tapAction()
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
    
    func tapAction() {
        switch registerMode {
        case .add:
            if self.textInput.value == "" { return }
            let locationData = LocationModel(
                name: self.textInput.value,
                address: self.address.value,
                latitude: self.latitude.value,
                longitude: self.longitude.value
            )
            LocationModel.add(locationData)
        case .edit:
            guard let index = selectedIndex.value else { return }
            let old = LocationModel.read()[index]
            let new = LocationModel(
                name: textInput.value,
                address: old.address,
                latitude: old.latitude,
                longitude: old.longitude
            )
            LocationModel.update(new: new, at: index)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

enum RegisterMode {
    case edit
    case add
}
