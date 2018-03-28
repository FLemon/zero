//
//  ViewController.swift
//  zero
//
//  Created by jinfeng xie on 27/03/2018.
//  Copyright © 2018 Alliants. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct TableViewSection {
    var header: String
    var items: [Item]
}

extension TableViewSection : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: TableViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let allCities = ["Shenzhen", "Guangzhou"]
    private let disposeBag = DisposeBag()
    private var searchedCities = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "cityPrototypeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "cityPrototypeCell")
                cell.textLabel?.text = item
                
                return cell
            },
            titleForHeaderInSection: { ds, index in
                return "Cities"
            }
        )
        
        let searchedCities = searchBar.rx.text.orEmpty.asDriver(onErrorJustReturn: "")
            .flatMapLatest { [unowned self] query in
                return Observable.just(self.allCities.filter { $0.hasPrefix(query) }).asDriver(onErrorJustReturn: [""])
            }
        
        searchedCities
            .map { [TableViewSection(header: "searchedResult", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
