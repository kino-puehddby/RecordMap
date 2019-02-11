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
import Presentr

final class SemiModalViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var favoriteList = BehaviorRelay<Results<LocationModel>>(value: LocationModel.read())
    var refreshTrigger = PublishSubject<Void>()
    var addFavoriteTrigger = PublishSubject<Void>()
    var selected = PublishSubject<Int>()
    var deleted = PublishSubject<Int>()
    var editTrigger = PublishSubject<Int>()
    
    let presenter: Presentr = Presentr(presentationType: .popup)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    func setup() {
        tableView.register(cellType: SemiModalTableViewCell.self)
    }
    
    func bind() {
        refreshTrigger.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.reloadTableView()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: selected)
            .disposed(by: disposeBag)
    }
    
    func reloadTableView() {
        let list = LocationModel.read()
        favoriteList.accept(list)
        tableView.reloadData()
    }
}

extension SemiModalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SemiModal.TableView.headerCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SemiModalTableViewHeader.loadFromNib()
        header.button.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                self.addFavoriteTrigger.onNext(())
            })
            .disposed(by: disposeBag)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SemiModal.TableView.heightForRow
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { [unowned self] (_, indexPath) in
            self.editAction(indexPath: indexPath)
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [unowned self] (_, indexPath) in
            self.deleteAction(indexPath: indexPath)
        }
        return [edit, delete]
    }
    
    func editAction(indexPath: IndexPath) {
        editTrigger.onNext(indexPath.row)
    }
    
    func deleteAction(indexPath: IndexPath) {
        favoriteList.value[indexPath.row].delete()
        tableView.deleteRows(at: [indexPath], with: .fade)
        deleted.onNext(indexPath.row)
    }
}

extension SemiModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as SemiModalTableViewCell
        cell.configuration(data: favoriteList.value[indexPath.row])
        return cell
    }
}

extension SemiModalViewController {
    var table: UITableView {
        return tableView
    }
}
