//
//  ClaimedDetailDataSource.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 15/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import LBTAComponents

class claimedDetailDataSource: Datasource {
    var itemNumber : String!
    var itemClaimed: [detailClaimed] = {
        return []
    }()
    
    
    override func numberOfItems(_ section: Int) -> Int {
        return itemClaimed.count
    }
    override func item(_ indexPath: IndexPath) -> Any? {
        return itemClaimed[indexPath.item]
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [ClaimDetailCustomCell.self]
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [ClaimedDetailHeader.self]
    }
    override func footerClasses() -> [DatasourceCell.Type]? {
        return [ClaimedDetailFooter.self]
    }
    
    
}
