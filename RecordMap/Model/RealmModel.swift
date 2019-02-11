//
//  RealmModel.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/02/08.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import RealmSwift

class RealmModel: Object {
    
    /**
     データの新規作成を行う
     */
    func write() {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(self)
            }
        } catch let error {
            debugPrint(error)
        }
    }
    
    /**
     データの削除を行う
     */
    func delete() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(self)
        }
    }
    
    /**
     データの追加を行う
     */
    class func add(_ object: Object) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            debugPrint(error)
        }
    }
}
