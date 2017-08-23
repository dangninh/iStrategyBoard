//
//  DNPlay.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 23/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import RealmSwift
class DNPlay: Object {
    let scenes = List<DNScene>()
    dynamic var id:Int = 0
    override static func primaryKey() -> String? {
        return "id"
    }
    static func nextID() -> Int {
        let realm = try! Realm()
        return (realm.objects(DNPlay.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
