//
//  PhotoReference+CoreDataProperties.swift
//  Progress Claim
//
//  Created by Quang Le Nguyen on 25/3/17.
//  Copyright © 2017 Quang Le Nguyen. All rights reserved.
//

import Foundation
import CoreData


extension PhotoReference {

    @nonobjc public class func CreatefetchRequest() -> NSFetchRequest<PhotoReference> {
        return NSFetchRequest<PhotoReference>(entityName: "PhotoReference");
    }

    @NSManaged public var timeStamp: Int16
    @NSManaged public var beforeTreatmentPhotoName: String
    @NSManaged public var beforeTreatmentPhotoURL: String
    @NSManaged public var afterTreatmentPhotoName: String
    @NSManaged public var afterTreatmentPhotoURL: String

}
