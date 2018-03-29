//
//  tableViewSection.swift
//  zero
//
//  Created by jinfeng xie on 29/03/2018.
//  Copyright © 2018 Alliants. All rights reserved.
//

import RxDataSources

struct TableViewSection {
    var header: String
    var items: [Item]
}

extension TableViewSection: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: TableViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
