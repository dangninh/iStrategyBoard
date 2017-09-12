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
                view.shapeLayer.removeFromSuperlayer()
                let paths = CGMutablePath()
                
                UIView.beginAnimations("rearangeViews", context: nil)
                UIView.setAnimationDuration(0.2)
                
                //
                for itemscene in curscene.sceneItems{
                    //find the item in current hashtable
					if let myitem = itemscene.item{
						if let centerpoint = itemscene.centerPoint(in: view.bounds){//item need to be shown
							if let itemview = view.itemhash[myitem]{
								//found: just update the center
								itemview.center = centerpoint
								view.addSubview(itemview)
							}
							else{
								//not found, create the view, add subview, update the hashtable
								print("\(String(describing: itemscene.item)), view.itemhash = \(view.itemhash)")
								let itemview = DNItemView(withItem: myitem, nextView: false)
                                itemview.center = centerpoint
								view.itemhash[myitem] = itemview
								view.addSubview(itemview)
							}
							if !view.viewModel!.animateMode{
								if let nextcenterpoint = itemscene.nextCenterPoint(in: view.bounds){
									let path = UIBezierPath()
									path.move(to: centerpoint)
									
									if let nextitemview = view.nextitemhash[myitem]{
										//found next view: just update the center
										nextitemview.center = nextcenterpoint
										view.addSubview(nextitemview)
									}
									else{
										//not found next view:, create the view, add subview, update the hashtable
										let nextitemview = DNItemView(withItem: myitem, nextView: true)
										nextitemview.alpha = 0.5 //alpha as 0.5 for next view
										nextitemview.center = nextcenterpoint
										view.nextitemhash[myitem] = nextitemview
										view.addSubview(nextitemview)
									}
									
									//myitem.type.color().set()
									
									path.lineWidth = 3.0
									path.lineCapStyle = .butt
									path.addLine(to: nextcenterpoint)
									paths.addPath(path.cgPath)
								}else{
									if let nextitemview = view.nextitemhash[myitem]{
										nextitemview.removeFromSuperview()
									}
								}
							}else{
								if let nextitemview = view.nextitemhash[myitem]{
									nextitemview.removeFromSuperview()
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
                
                view.shapeLayer.strokeColor = UIColor.gray.cgColor
                view.shapeLayer.opacity = 1.0
                
                view.shapeLayer.lineDashPattern = [ 5.0, 6.0 ]
                view.shapeLayer.path = paths
                view.layer.addSublayer(view.shapeLayer)
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
    var shapeLayer = CAShapeLayer()
	
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.addSublayer(shapeLayer)
    }
    var viewModel : DNBoardViewModel?{
        didSet{
            let disposebag = DisposeBag()
            if let vm = viewModel{
                //Observable.from(object: vm.currentScene).bind(to: self.rx.scene).disposed(by: disposebag)
                
                vm.currentScene.asDriver().drive(self.rx.scene).disposed(by: disposebag)
            }
            self.disposeBag = disposebag
        }
    }
    var itemhash:[DNItem:DNItemView] = [:]
    var nextitemhash:[DNItem:DNItemView] = [:]
}
