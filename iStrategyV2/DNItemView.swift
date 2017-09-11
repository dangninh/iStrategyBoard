//
//  DNItemView.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 4/9/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class DNItemView:UIView{
    static let itemsize = CGSize(width: 40, height: 40)
    let item : DNItem
	var isNextView = false
	init(withItem item:DNItem, nextView:Bool){
        self.item = item
		isNextView = nextView
		
        super.init(frame: CGRect(x: 0, y: 0, width: DNItemView.itemsize.width, height: DNItemView.itemsize.height))
		self.alpha = isNextView ? 0.1 : 1
		
        let image = item.type.image()
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        imageView.tintColor = item.type.color()
		
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(DNItemView.draggedView(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func draggedView(_ sender:UIPanGestureRecognizer){
        if let boardview = self.superview as? DNBoardView{
			if boardview.inMovingMode{
				
			}else{
				boardview.bringSubview(toFront: self)
				let translation = sender.translation(in: boardview)
				self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
				sender.setTranslation(CGPoint.zero, in: boardview)
				if sender.state == .ended{
					//update view model
					
					if boardview.frame.size.width>boardview.frame.size.height{
						boardview.viewModel?.update(item: self.item, current: Float(self.center.y/boardview.frame.size.height), pos_y: Float(self.center.x/boardview.frame.size.width))
						
					}else{
						boardview.viewModel?.update(item: self.item, current: Float(self.center.x/boardview.frame.size.width), pos_y: 1.0-Float(self.center.y/boardview.frame.size.height))
					}
				}
			}
			
        }
		
    }
}
