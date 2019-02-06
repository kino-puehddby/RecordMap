//
//  ModalViewController.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/02/05.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RealmSwift

final class ModalViewController: UIViewController {

    @IBOutlet weak private var modalView: UIView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var desideButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let textInput = BehaviorRelay<String>(value: "")
    
    let realm = try! Realm()
    
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
                locationData.location.latitude = 0 // FIXME: データ引き継ぎ
                locationData.location.longitude = 0 // FIXME データ引き継ぎ
                self.realm.addCustom(locationData)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ModalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
