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
    init(restore isRestore:Bool){
        if isRestore{
            play = realm.objects(DNPlay.self).last ?? DNPlay()
            currentSceneIndex = 0
            currentScene = Variable(play.scenes.first ?? DNScene())
            try! realm.write {
                realm.add(play,update:true)
            }
        }
        else{
            play = DNPlay()
            play.id = DNPlay.nextID()
            let newScene = DNScene()
            currentScene = Variable(newScene)
            play.scenes.append(newScene)
            try! realm.write {
                realm.add(play)
            }
        }
        
        
    }
    init(with oldplay:DNPlay){
        play=oldplay
        currentSceneIndex = 0
        currentScene = Variable(play.scenes.first ?? DNScene())
    }
    func refresh(){
        currentScene.value = currentScene.value
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
        currentScene.value = copyScene
    }
    func add(item:DNSceneItem){
        try! realm.write {
            //let currentScene = play.scenes[currentSceneIndex]
            currentScene.value.sceneItems.append(item)
            self.refresh()
        }
        
    }
    func addItems(from formation:DNFormation, to side:DNSide){
        
    }
	func update(item:DNItem, current pos_x : Float, pos_y : Float){
		if let sceneitem = currentScene.value.getSceneItem(for: item){
			try! realm.write {
				sceneitem.x_pos = pos_x
				sceneitem.y_pos = pos_y
                self.refresh()
			}
            
		}
	}
	func update(item:DNItem, next pos_x : Float, pos_y : Float){
		if let sceneitem = currentScene.value.getSceneItem(for: item){
			try! realm.write {
				sceneitem.next_x_pos = pos_x
				sceneitem.next_y_pos = pos_y
                self.refresh()
			}
            
		}
	}
}
