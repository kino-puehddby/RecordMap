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
    }
}

extension SemiModalViewController: UITableViewDelegate {
    
}

extension SemiModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SemiModalTableViewCell.self)
        cell.configuration(data: favoriteList?[indexPath.row] ?? LocationData())
        return cell
    }
}
