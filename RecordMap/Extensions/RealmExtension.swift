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
            print("*** Realm Error: can't add object to realm ***")
        }
    }
}

protocol RealmUsable {
    static var filePath: String { get }
    static var config: Realm.Configuration { get }
    static var schema: Realm.Configuration { get }
    static func createRealm() -> Realm?
    static  func addFileURL(config: Realm.Configuration) -> Realm.Configuration
}

extension RealmUsable {
    static var config: Realm.Configuration {
        var c = schema
        c.fileURL = c.fileURL?
            .deletingLastPathComponent()
            .appendingPathComponent(filePath)
            .appendingPathExtension("realm")
        return c
    }
    
    static var schema: Realm.Configuration {
        return Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, oldSchemmaVersion in
                if oldSchemmaVersion < 1 { }
        })
    }
    
    static func createRealm() -> Realm? {
        do {
            return try Realm(configuration: config)
        } catch {
            assertionFailure("realm error: \(error)")
            var config = self.config
            config.deleteRealmIfMigrationNeeded = true
            return try? Realm(configuration: config)
        }
    }
}
