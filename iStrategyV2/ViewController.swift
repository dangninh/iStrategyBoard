//
//  ViewController.swift
//  iStrategyV2
//
//  Created by Ha Dang Ninh on 3/6/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import UIKit
import RxSwift
import Floaty
enum FloatyTitle:String{
    case AddHome = "Add Home Player"
    case AddAway = "Add Away Player"
    case AddBall = "Add Ball"
    case AddCone = "Add Cone"
    case AddScene = "Add Scence"
}
class ViewController: UIViewController {
    
    
    var capture:DNVideoCapture?
    var disposeBag = DisposeBag()
    @IBOutlet var boardView:DNBoardView!
    
	override func viewDidLoad() {
        capture = DNVideoCapture(view: self.boardView)
        self.boardView.viewModel = DNBoardViewModel(restore:true)
        
        self.createFloatMenu()
		super.viewDidLoad()
        
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    func createFloatMenu(){
        let floaty = Floaty()
        let handler: ((FloatyItem) -> Void) = { item in
            if let itemTitle = FloatyTitle(rawValue: item.title ?? ""){
                switch itemTitle{
                case .AddHome:
                    self.boardView.viewModel?.add(item: DNSceneItem.newSceneItem(with:.PlayerHome))
				case .AddAway:
					self.boardView.viewModel?.add(item: DNSceneItem.newSceneItem(with:.PlayerAway))
				case .AddCone:
					self.boardView.viewModel?.add(item: DNSceneItem.newSceneItem(with:.Cone))
				case .AddBall:
					self.boardView.viewModel?.add(item: DNSceneItem.newSceneItem(with:.Ball))
                case .AddScene:
                    self.boardView.viewModel?.duplicateCurrentScene()
                default:
                    break
                }
            }
        }
        floaty.addItem(title: FloatyTitle.AddHome.rawValue, handler: handler)
        floaty.addItem(title: FloatyTitle.AddAway.rawValue, handler: handler)
        floaty.addItem(title: FloatyTitle.AddCone.rawValue, handler: handler)
        floaty.addItem(title: FloatyTitle.AddScene.rawValue, handler: handler)
        
        self.view.addSubview(floaty)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        //self.boardViewModel?.refresh()
    }
}
extension FloatyItem{
}
class ReactiveFloatyItem:FloatyItem{
    
}
