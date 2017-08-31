//
//  DNBoardViewModel.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 23/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import RealmSwift
class DNFormation{
    
}
enum DNSide{
    case Home
    case Away
}
enum DNItemShape{
    case Shirt
    case Circle
    case Picture
}
struct DNPlaySetting{
    var homeColor:UIColor
    var awayColor:UIColor
    var shape:DNItemShape
}
class DNBoardViewModel{
    var play:DNPlay
    var currentSceneIndex = 0
    let realm = try! Realm()
    init(){
        play = DNPlay()
        play.id = DNPlay.nextID()
        play.scenes.append(DNScene())
        try! realm.write {
            realm.add(play)
        }
    }
    init(with oldplay:DNPlay){
        play=oldplay
    }
    func save(){
        try! realm.write {
            realm.add(play,update:true)
        }
    }
    func duplicateCurrentScene(){
        let copyScene = play.scenes[currentSceneIndex].duplicate()
        currentSceneIndex += 1
        play.scenes.insert(copyScene, at: currentSceneIndex)
    }
    func add(item:DNSceneItem){
        let currentScene = play.scenes[currentSceneIndex]
        currentScene.sceneItems.append(item)
    }
    func addItems(from formation:DNFormation, to side:DNSide){
        
    }
}
