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

final class ModalViewController: UIViewController {

    @IBOutlet weak private var modalView: UIView!
    @IBOutlet weak private var closeButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
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
    }
}
