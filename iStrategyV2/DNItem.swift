//
//  DNItem.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 23/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import RealmSwift
enum DNItemType: String {
    case PlayerHome = "PlayerHome"
    case PlayerAway = "PlayerAway"
    case Ball = "Ball"
    case Cone = "Cone"
}
class DNItem: Object {
    private dynamic var privateType = DNItemType.PlayerHome.rawValue
    var type: DNItemType {
        get { return DNItemType(rawValue: privateType)! }
        set { privateType = newValue.rawValue }
    }
    dynamic var info:DNPlayerInfo?
    dynamic var id:Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    static func nextID() -> Int {
        let realm = try! Realm()
        return (realm.objects(DNItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
class DNPlayerInfo: Object{
    dynamic var name = ""
    dynamic var number = ""
}
class DNSceneItem:Object{
    dynamic var item:DNItem?
    dynamic var x_pos:Float = -1.0 //must be between 0..1, all other value will be treated as outside current scene
    dynamic var y_pos:Float = -1.0 //must be between 0..1, all other value will be treated as outside current scene
    func duplicate()->DNSceneItem{
        let copy = DNSceneItem()
        copy.item = self.item //use old item
        copy.x_pos = self.x_pos
        copy.y_pos = self.y_pos
        return copy
    }
}
