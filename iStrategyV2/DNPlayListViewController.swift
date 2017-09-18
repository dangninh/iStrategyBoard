//
//  DNPlayListViewController.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 18/9/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DNPlayListViewController: UIViewController {
    var disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let items = Observable.just(
            DNPlay.allPlays()
        )
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name)"
                cell.accessoryType = element.active ? .checkmark : .none
            }
            .disposed(by: disposeBag)
        
        
        tableView.rx
            .modelSelected(DNPlay.self)
            .subscribe(onNext:  {[weak self] play in
                play.setActive()
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
