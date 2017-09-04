//
//  DNBoardViewModel.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 23/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa
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
    var currentScene : Variable<DNScene>
    let realm = try! Realm()
    init(){
        play = DNPlay()
        play.id = DNPlay.nextID()
        let newScene = DNScene()
        currentScene = Variable(newScene)
        play.scenes.append(newScene)
        try! realm.write {
            realm.add(play)
        }
    }
    init(with oldplay:DNPlay){
        play=oldplay
        currentSceneIndex = 0
        currentScene = Variable(play.scenes.first ?? DNScene())
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
