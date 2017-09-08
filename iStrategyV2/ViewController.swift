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
    var boardViewModel:DNBoardViewModel?
    
    
    var capture:DNVideoCapture?
    var disposeBag = DisposeBag()
    @IBOutlet var boardView:DNBoardView!
    
	override func viewDidLoad() {
        capture = DNVideoCapture(view: self.boardView)
        boardViewModel = DNBoardViewModel()
        boardViewModel!.currentScene.asDriver().drive(boardView.rx.scene).disposed(by: disposeBag)
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
                    self.boardViewModel?.add(item: DNSceneItem.newSceneItem(with:.PlayerHome))
                    self.boardViewModel?.refresh()
                case .AddScene:
                    self.boardViewModel?.duplicateCurrentScene()
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
        self.boardViewModel?.refresh()
    }
}
extension FloatyItem{
}
class ReactiveFloatyItem:FloatyItem{
    
}
