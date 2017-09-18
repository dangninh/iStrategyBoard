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
    dynamic var name:String = ""
    dynamic var active = false
    override static func primaryKey() -> String? {
        return "id"
    }
    static func nextID() -> Int {
        let realm = try! Realm()
        return (realm.objects(DNPlay.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    static func activePlay() -> DNPlay?{
        let realm = try! Realm()
        return realm.objects(DNPlay.self).filter("active == true").first
    }
    static func allPlays() -> [DNPlay]{
        let realm = try! Realm()
        return realm.objects(DNPlay.self).map{$0}
    }
    func setActive(){
        let realm = try! Realm()
        let currActive = DNPlay.activePlay()
        try! realm.write {
            currActive?.active = false
            self.active = true
        }
    }
}
