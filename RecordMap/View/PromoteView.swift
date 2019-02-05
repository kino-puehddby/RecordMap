//
//  PromoteView.swift
//
//  Created by 杉田 尚哉 on 2019/02/01.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

final class PromoteView: UIView, NibLoadable {
    
    @IBOutlet weak private var jumpToSetting: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        jumpToSetting.rx.tap
            .subscribe(onNext: {
                guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
    }
}
