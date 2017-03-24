//
//  DataSource.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 14/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import LBTAComponents

class TenderScheduleDataSource: Datasource {
    let MRTS: [workItem] = {
        let I120101 = workItem(itemNumber: 1201.01, itemDescription: "MRTS02 Provision for Traffic (April 2016)", itemDetailDescription: "Provision for Traffic", itemQuantity: 1,unitRate: "lump sum")
        
        let I133101 = workItem(itemNumber: 1331.01, itemDescription: "MRTS51 Environmental Management (Octorber 2016)", itemDetailDescription: "Develop Environemntal Management Plan (Construction)", itemQuantity: 1, unitRate: "lump sum")
        
        let I133201 = workItem(itemNumber: 1332.01, itemDescription: "MRTS51 Environmental Management (Octorber 2016", itemDetailDescription: "Implement Environmental Management Plan", itemQuantity: 1, unitRate: "lump sum")
        let I900101 = workItem(itemNumber: 9001.01, itemDescription: "Project Specific Specification", itemDetailDescription: "High Pressure Water Blasting", itemQuantity: 133333, unitRate: "m2")
        
        return [I120101,I133101,I133201,I900101]
    }()
    
    override func numberOfItems(_ section: Int) -> Int {
        return MRTS.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return MRTS[indexPath.item]
    }
    override func cellClasses() -> [DatasourceCell.Type] {
        return [customCell.self]
    }
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [tenderHeader.self]
    }
    override func footerClasses() -> [DatasourceCell.Type]? {
        return [tenderFooter.self]
    }
}
