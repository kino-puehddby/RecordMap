//
//  SemiModalTableViewHeaderView.swift
//  RecordMap
//
//  Created by HisayaSugita on 2019/02/10.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit

import Reusable

class SemiModalTableViewHeader: UIView, NibReusable {
    
    @IBOutlet weak fileprivate var favoriteRegisterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteRegisterButton.setImage(Asset.add.image.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteRegisterButton.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    }
}

extension SemiModalTableViewHeader {
    var button: UIButton {
        return favoriteRegisterButton
    }
}
