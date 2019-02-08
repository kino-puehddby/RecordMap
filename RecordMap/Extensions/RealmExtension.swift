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
    public func customAdd(_ object: Object) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            debugPrint("*** realm error: can't add object to realm ***")
        }
    }
}
