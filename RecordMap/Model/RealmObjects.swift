//
//  RealmObjects.swift
//  RecordMap
//
//  Created by HisayaSugita on 2019/02/07.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import Foundation
import RealmSwift

class LocationData: Object {
    @objc dynamic var name = ""
    @objc dynamic var location = Location()
}

class Location: Object {
    @objc dynamic var latitude = 0
    @objc dynamic var longitude = 0
}
