//
//  RealmMigrator.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/02/08.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import Realm
import RealmSwift

final class RealmMigrator: NSObject {
    
    private static let schemaVersion: UInt64 = 5
    
    static func executeMigration() {
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
            var order = 0
            migration.enumerateObjects(ofType: LocationModel.className(), { _, new in
                if oldSchemaVersion < 3 {
                    new!["order"] = order
                    order -= 1
                }
            })
        })
        Realm.Configuration.defaultConfiguration = config
    }
}
