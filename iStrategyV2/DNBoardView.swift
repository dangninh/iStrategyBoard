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
        return UIBindingObserver(UIElement: base) { view, scene in
            if let curscene = scene{
                UIView.beginAnimations("rearangeViews", context: nil)
                UIView.setAnimationDuration(0.2)
                
                view.disposeBag = DisposeBag()
                //
                for itemscene in curscene.sceneItems{
                    //find the item in current hashtable
					if let myitem = itemscene.item{
						if let centerpoint = itemscene.centerPoint(in: view.bounds){//item need to be shown
							if let itemview = view.itemhash[myitem]{
								//found: just update the center
								itemview.center = centerpoint
							}
							else{
								//not found, create the view, add subview, update the hashtable
								print("\(String(describing: itemscene.item)), view.itemhash = \(view.itemhash)")
								let itemview = DNItemView(withItem: myitem)
								itemview.center = centerpoint
								view.itemhash[myitem] = itemview
								view.addSubview(itemview)
							}
							if let nextcenterpoint = itemscene.nextCenterPoint(in: view.bounds){
								if let nextitemview = view.nextitemhash[myitem]{
									//found next view: just update the center
									nextitemview.center = nextcenterpoint
								}
								else{
									//not found next view:, create the view, add subview, update the hashtable
									let nextitemview = DNItemView(withItem: myitem)
									nextitemview.alpha = 0.5 //alpha as 0.5 for next view
									nextitemview.center = nextcenterpoint
									view.nextitemhash[myitem] = nextitemview
									view.addSubview(nextitemview)
								}
							}
							
						}else{
							//item shouldn't be shown
							if let itemview = view.itemhash[myitem]{
								itemview.removeFromSuperview()
							}
							if let nextitemview = view.nextitemhash[myitem]{
								nextitemview.removeFromSuperview()
							}
						}
					}
                }
                //remove view no longer in the scene
                let items = curscene.sceneItems.flatMap({ $0.item })
                for (item,itemview) in view.itemhash{
                    if !items.contains(item){
                        itemview.removeFromSuperview()
						view.nextitemhash[item]?.removeFromSuperview()
                    }
                }
                UIView.commitAnimations()
            }
            
        }
    }
    
    
}

class DNBoardView:UIView{
    var disposeBag: DisposeBag?
	var inMovingMode : Bool = false
    var viewModel : DNBoardViewModel?{
        didSet{
            let disposeBag = DisposeBag()
            if let vm = viewModel{
                vm.currentScene.asDriver().drive(self.rx.scene).disposed(by: disposeBag)
            }
            self.disposeBag = disposeBag
        }
    }
    var itemhash:[DNItem:DNItemView] = [:]
    var nextitemhash:[DNItem:DNItemView] = [:]
}
