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
    case NewPlay = "New Play"
}
class DNMainBoardViewController: UIViewController {
    
    
    var capture:DNVideoCapture?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet var boardView:DNBoardView!
    
	override func viewDidLoad() {
        capture = DNVideoCapture(view: self.videoView)
        let listButtonn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(DNMainBoardViewController.listButtonTapped(_:)))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(DNMainBoardViewController.recordButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [shareButton,listButtonn]
        self.createFloatMenu()
		super.viewDidLoad()
        
		// Do any additional setup after loading the view, typically from a nib.
	}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.boardView.viewModel = DNBoardViewModel(restore:true)
        self.navigationItem.title = self.boardView.viewModel?.play.name ?? ""
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
                case .NewPlay:
                    self.boardView.viewModel = DNBoardViewModel(restore:false)
                    self.navigationItem.title = self.boardView.viewModel?.play.name ?? ""
                default:
                    break
                }
            }
        }
        floaty.addItem(title: FloatyTitle.AddHome.rawValue, handler: handler)
        floaty.addItem(title: FloatyTitle.AddAway.rawValue, handler: handler)
		floaty.addItem(title: FloatyTitle.AddBall.rawValue, handler: handler)
        floaty.addItem(title: FloatyTitle.AddCone.rawValue, handler: handler)
        floaty.addItem(title: FloatyTitle.AddScene.rawValue, handler: handler)
        floaty.addItem(title: FloatyTitle.NewPlay.rawValue, handler: handler)
        self.view.addSubview(floaty)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        self.boardView.viewModel?.refresh()
    }
	@IBAction func prevButtonTapped(_ sender: Any) {
		self.boardView.viewModel?.previous()
	}
	@IBAction func playPause(_ sender: Any) {
		self.boardView.viewModel?.playAnimate()
	}
	@IBAction func nextButtonTapped(_ sender: Any) {
		self.boardView.viewModel?.next()
	}
    func listButtonTapped(_ sender: Any){
        self.performSegue(withIdentifier: "gotolist", sender: nil)
    }
    func recordButtonTapped(_ sender: Any){
        //self.performSegue(withIdentifier: "gotolist", sender: nil)
        capture?.startRecording()
        self.boardView.viewModel?.playAnimate(complete: {[weak self] in
            self?.capture?.stop(callback: { (info) in
                
                if let fileurl = info["file_url"] as? URL{
                    let objectsToShare = [fileurl]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    self?.present(activityVC, animated: true, completion: nil)
                }
            })
        })
    }
}
extension FloatyItem{
}
class ReactiveFloatyItem:FloatyItem{
    
}
