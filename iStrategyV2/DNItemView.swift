//
//  DNItemView.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 4/9/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import UIKit
class DNItemView:UIView{
    static let itemsize = CGSize(width: 40, height: 40)
    init(withType type:DNItemType){
        super.init(frame: CGRect(x: 0, y: 0, width: DNItemView.itemsize.width, height: DNItemView.itemsize.height))
        let image = type.image()
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        imageView.tintColor = type.color()
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
