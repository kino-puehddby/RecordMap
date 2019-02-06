//
//  RealmExtension.swift
//  RecordMap
//
//  Created by HisayaSugita on 2019/02/07.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    // - add
    public func addCustom(_ object: Object) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("*** Realm Error: can't add object to realm ***")
        }
    }
}
