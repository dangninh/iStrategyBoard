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
    func image()->UIImage{
        switch self {
        case .PlayerHome,.PlayerAway:
            return UIImage(named: (UserDefaults.standard.string(forKey: "PlayerImage") ?? "shirt"))!.withRenderingMode(.alwaysTemplate)
        case .Ball:
            return UIImage(named: "ball")!.withRenderingMode(.alwaysOriginal)
        case .Cone:
            return UIImage(named: "cone")!.withRenderingMode(.alwaysOriginal)
        }
    }
    func color()->UIColor{
        switch self {
        case .PlayerHome:
            return (UserDefaults.standard.object(forKey: "HomeColor") as? UIColor) ?? UIColor.red
        case .PlayerAway:
            return (UserDefaults.standard.object(forKey: "AwayColor") as? UIColor) ?? UIColor.black
        default:
            return UIColor.clear
        }
    }
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
    static func newItem(with type:DNItemType)->DNItem{
        let newitem = DNItem()
        newitem.id = nextID()
        newitem.type = type
        newitem.info = nil
        return newitem
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
    dynamic var next_x_pos:Float = -1.0 //must be between 0..1, all other value will be treated as outside current scene
    dynamic var next_y_pos:Float = -1.0 //must be between 0..1, all other value will be treated as outside current scene
    func duplicate()->DNSceneItem{
        let copy = DNSceneItem()
        copy.item = self.item //use old item
        copy.x_pos = self.x_pos
        copy.y_pos = self.y_pos
        return copy
    }
    static func newSceneItem(with type:DNItemType)->DNSceneItem{
        let newSceneItem = DNSceneItem()
        newSceneItem.item = DNItem.newItem(with: type)
        newSceneItem.x_pos = 0.5
        newSceneItem.y_pos = 0.5
        newSceneItem.next_x_pos = -1
        newSceneItem.next_y_pos = -1
        return newSceneItem
    }
    func centerPoint(in rect:CGRect)->CGPoint?{
		if x_pos<0 || x_pos>1 || y_pos<0 || y_pos>1 {
			return nil
		}
        if rect.size.width>rect.size.height{
            return CGPoint(x:rect.origin.x + CGFloat(y_pos)*rect.width,y:rect.origin.y + CGFloat(x_pos)*rect.height)
            
        }else{
            return CGPoint(x:rect.origin.x + CGFloat(x_pos)*rect.width,y:rect.origin.y + rect.height - CGFloat(y_pos)*rect.height)
        }
        
    }
	func nextCenterPoint(in rect:CGRect)->CGPoint?{
		if next_x_pos<0 || next_x_pos>1 || next_y_pos<0 || next_y_pos>1 {
			return nil
		}
		if rect.size.width>rect.size.height{
			return CGPoint(x:rect.origin.x + CGFloat(next_y_pos)*rect.width,y:rect.origin.y + CGFloat(next_x_pos)*rect.height)
			
		}else{
			return CGPoint(x:rect.origin.x + CGFloat(next_x_pos)*rect.width,y:rect.origin.y + rect.height - CGFloat(next_y_pos)*rect.height)
		}
	}
}
