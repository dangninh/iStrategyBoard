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
import RealmSwift
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
                UIView.beginAnimations("rearangeViews", context: nil)
                UIView.setAnimationDuration(0.5)
                
                view.disposeBag = DisposeBag()
                //
                for itemscene in curscene.sceneItems{
                    //find the item in current hashtable
                    if let myitem = itemscene.item, let itemview = view.itemhash[myitem]{
                        //found: just update the center
                        itemview.center = itemscene.centerPoint(in: view.bounds)
                        itemview.positionVal.asObservable().subscribe(onNext: { (val) in
                            try! Realm().write {
                                itemscene.x_pos = val.0
                                itemscene.y_pos = val.1
                            }
                            
                        }).disposed(by: view.disposeBag)
                    }else{
                        //not found, create the view, add subview, update the hashtable
                        print("\(String(describing: itemscene.item)), view.itemhash = \(view.itemhash)")
                        if let item = itemscene.item{
                            let itemview = DNItemView(withItem: item)
                            itemview.positionVal.value = (itemscene.x_pos,itemscene.y_pos)
                            itemview.center = itemscene.centerPoint(in: view.bounds)
                            
                            itemview.positionVal.asObservable().subscribe(onNext: { (val) in
                                try! Realm().write {
                                    itemscene.x_pos = val.0
                                    itemscene.y_pos = val.1
                                }
                                
                            }).disposed(by: view.disposeBag)
                            view.itemhash[item] = itemview
                            view.addSubview(itemview)
                            
                        }
                    }
                }
                //remove view no longer in the scene
                let items = curscene.sceneItems.flatMap({ $0.item })
                
                for (item,itemview) in view.itemhash{
                    if !items.contains(item){
                        itemview.removeFromSuperview()
                    }
                }
                UIView.commitAnimations()
            }
            
        }
    }
    
}

class DNBoardView:UIView{
    var itemhash:[DNItem:DNItemView] = [:]
    var disposeBag = DisposeBag()
}
