//
//  DNBoardView.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 4/9/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
extension Reactive where Base: DNBoardView {
    var scene: UIBindingObserver<Base, DNScene?> {
        return scene(transitionType: nil)
    }
    func scene(transitionType: String? = nil) -> UIBindingObserver<Base, DNScene?> {
        return UIBindingObserver(UIElement: base) { view, scene in
            if let transitionType = transitionType {
                if scene != nil {
                    let transition = CATransition()
                    transition.duration = 0.25
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.type = transitionType
                    view.layer.add(transition, forKey: kCATransition)
                }
            }
            else {
                view.layer.removeAllAnimations()
            }
            if let curscene = scene{
                for item in curscene.sceneItems{
                    //find the item in current hashtable
                    if let itemview = view.itemhash[item]{
                        //found: just update the center
                        itemview.center = item.centerPoint(in: view.bounds)
                    }else{
                        //not found, create the view, add subview, update the hashtable
                        if let type = item.item?.type{
                            let itemview = DNItemView(withType: type)
                            itemview.center = item.centerPoint(in: view.bounds)
                            view.addSubview(itemview)
                            view.itemhash[item] = itemview
                        }
                    }
                }
                //remove view no longer in the scene
                for (item,itemview) in view.itemhash{
                    if curscene.sceneItems.index(of: item) == nil{
                        itemview.removeFromSuperview()
                        //todo: remove from the hash?
                    }
                }
            }
            
        }
    }
}

class DNBoardView:UIView{
    fileprivate var itemhash:[DNSceneItem:DNItemView] = [:]
}
