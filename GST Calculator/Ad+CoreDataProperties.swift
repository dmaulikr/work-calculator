//
//  Ad+CoreDataProperties.swift
//  
//
//  Created by Andrew Foster on 7/14/17.
//
//

import Foundation
import CoreData


extension Ad {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ad> {
        return NSFetchRequest<Ad>(entityName: "Ad")
    }

    @NSManaged public var purchased: Bool
    @NSManaged public var title: String?
    @NSManaged public var productIdentifier: String?

}
