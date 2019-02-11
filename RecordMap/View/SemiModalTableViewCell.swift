//
//  SemiModalTableViewCell.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/02/07.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit

import Reusable

final class SemiModalTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak private var tagLabel: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configuration(data: LocationModel) {
        nameLabel.text = data.name
        addressLabel.text = data.address
    }
}
