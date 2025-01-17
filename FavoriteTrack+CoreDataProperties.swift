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
        let request = NSFetchRequest<FavoriteTrack>(entityName: "FavoriteTrack")
        request.sortDescriptors = [NSSortDescriptor(key: "orderId", ascending: true)]
        return request
    }
    
    @nonobjc public class func fetchRequestSingle(trackId: String) -> NSFetchRequest<FavoriteTrack> {
        let request = NSFetchRequest<FavoriteTrack>(entityName: "FavoriteTrack")
        request.predicate = NSPredicate(format: "trackId == %@", trackId)
        return request
    }

    @NSManaged public var trackId: String?
    @NSManaged public var artistName: String?
    @NSManaged public var trackName: String?
    @NSManaged public var orderId: Int32
    @NSManaged public var duration: String?

}
