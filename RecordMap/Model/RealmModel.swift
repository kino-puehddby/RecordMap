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
     データの更新を行う
     */
    func update(update: () -> Void) {
        let realm = try! Realm()
        
        do {
            try realm.write {
                update()
            }
        } catch let error {
            debugPrint(error)
        }
    }
    
    func add(_ object: Object) {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            debugPrint("*** realm error: can't add object to realm ***")
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
     データの削除を行う
     */
    class func delete() {
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(realm.objects(self))
            }
        } catch let error {
            debugPrint(error)
        }
    }
}
