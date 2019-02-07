//
//  RealmObjects.swift
//  RecordMap
//
//  Created by HisayaSugita on 2019/02/07.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import Foundation
import RealmSwift

final class LocationData: Object {
    @objc dynamic var name: String?
    @objc dynamic var address: String?
    @objc dynamic var location: Location? // リレーションオブジェクトははOptionalにしないとcrashしてしまう
}

final class Location: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
}
