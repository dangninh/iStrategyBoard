//
//  DNScene.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 23/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import RealmSwift
class DNScene: Object {
    let sceneItems = List<DNSceneItem>()
    func duplicate()->DNScene{
        let copy = DNScene()
        for item in self.sceneItems{
            copy.sceneItems.append(item.duplicate())
        }
        return copy
    }
}
