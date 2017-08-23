//
//  ViewController.swift
//  iStrategyV2
//
//  Created by Ha Dang Ninh on 3/6/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import UIKit
import RxSwift
class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    var capture:DNVideoCapture?
    var disposeBag = DisposeBag()
	override func viewDidLoad() {
        capture = DNVideoCapture(view: self.view)
		super.viewDidLoad()
        Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
            .subscribe({ sec -> Void in
                UIView.animate(withDuration: 0.4, animations: {
                    self.button.frame = CGRect(x:CGFloat(drand48())*self.view.frame.size.width, y: CGFloat(drand48())*self.view.frame.size.height, width:self.button.frame.size.width,height:self.button.frame.size.height)
                })
            }).addDisposableTo(disposeBag)
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    @IBAction func buttonTapped(_ sender: Any) {
        let button = sender as! UIButton
        button.isSelected = !(button.isSelected)
        if !capture!.isRecording{
            capture!.startRecording()
        }else{
            capture!.stop()
        }
    }
}

