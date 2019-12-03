//
//  FavoriteTrack+CoreDataProperties.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 02/12/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTrack> {
        return NSFetchRequest<FavoriteTrack>(entityName: "FavoriteTrack")
    }

    @NSManaged public var trackId: String?
    @NSManaged public var artistName: String?
    @NSManaged public var trackName: String?
    @NSManaged public var orderId: Int32
    @NSManaged public var duration: String?

}
