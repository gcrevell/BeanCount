//
//  Location+CoreDataProperties.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 7/24/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import Foundation
import CoreData

extension Location {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String?
    @NSManaged var uid: String?
    @NSManaged var city: String?
    @NSManaged var state: String?

}
