//
//  RealmObjects.swift
//  RecordMap
//
//  Created by HisayaSugita on 2019/02/07.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import Foundation
import RealmSwift

final class LocationModel: RealmModel {
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    convenience init(name: String, address: String, latitude: Double, longitude: Double) {
        self.init()
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /**
     データの読み込みを行う
     */
    static func read() -> Results<LocationModel> {
        let realm = try! Realm()
        return realm.objects(self)
    }
    
    static func update(new: LocationModel, at index: Int) {
        let realm = try! Realm()
        var target = LocationModel.read()[index]
        do {
            try realm.write {
                target.name = new.name
                target.address = new.address
                target.latitude = new.latitude
                target.longitude = new.longitude
            }
        } catch {
            debugPrint("\(error) at \(target)")
        }
    }
}
