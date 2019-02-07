//
//  SemiModalViewController.swift
//  RecordMap
//
//  Created by 杉田 尚哉 on 2019/02/04.
//  Copyright © 2019 hisayasugita. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RealmSwift

final class SemiModalViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    private let realm = try! Realm()
    
    private let disposeBag = DisposeBag()
    var favoriteList: [LocationData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        favoriteList = Array(realm.objects(LocationData.self))
        tableView.register(cellType: SemiModalTableViewCell.self)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] indexPath in
                self.favoriteList?.remove(at: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}

extension SemiModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SemiModal.TableView.heightForRow
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard var list = favoriteList else { return }
            try! realm.write {
                realm.delete(list[indexPath.row])
            }
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension SemiModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as SemiModalTableViewCell
        cell.configuration(data: favoriteList?[indexPath.row] ?? LocationData())
        return cell
    }
}

extension SemiModalViewController {
    var table: UITableView {
        return tableView
    }
}
