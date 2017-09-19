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
import RxRealm
import RealmSwift
class DNPlayListViewController: UIViewController {
    var disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        Observable.collection(from: realm.objects(DNPlay.self))
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
        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
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
extension DNPlayListViewController:UITableViewDelegate{
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        let editRowAction = UITableViewRowAction(style: .default, title: "Rename", handler:{action, indexpath in
            let curPlay = try! tableView.rx.model(at: indexPath) as DNPlay
            let alert = UIAlertController(title: "StrategyBoard", message: "Rename?", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                textField.placeholder = curPlay.name
            })
            alert.addAction(UIAlertAction(title: "Rename", style: .destructive, handler: { (action) in
                if let newname = alert.textFields?[0].text {
                    curPlay.rename(newname: newname)
                }
            }))
            self.present(alert, animated: true, completion: {
                
            })
        });
        editRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let deleteRowAction = UITableViewRowAction(style: .default, title: "Delete", handler:{action, indexpath in
            let curPlay = try! tableView.rx.model(at: indexPath) as DNPlay
            let alert = UIAlertController(title: "StrategyBoard", message: "Delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                curPlay.deleteRecord()
            }))
            self.present(alert, animated: true, completion: {
                
            })
        });
        
        return [deleteRowAction, editRowAction];
    }
    
}
