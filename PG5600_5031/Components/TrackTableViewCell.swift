//
//  TrackTableViewCell.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 23/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TrackTableViewCell : UITableViewCell {
    
    /* UI */
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    /* Other */
    let nonFilledStar = UIImage(named: "icons8-star")?.withRenderingMode(.alwaysTemplate)
    let tintedFilledStar = UIImage(named: "icons8-star_filled")?.withRenderingMode(.alwaysTemplate)
    var isFavorite: Bool = false
    var artistName: String?
    var trackId: String?
    var orderId: Int32?
    var onStaredChanged: (() -> Void)?
    
    /* CoreData */
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil
    var favoriteTracksEntity: NSEntityDescription? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.context = appDelegate.persistentContainer.viewContext
        self.favoriteTracksEntity = NSEntityDescription.entity(forEntityName: "FavoriteTrack", in: context!)
        
        styleStarImage()
    }
    
    override func layoutSubviews() {
        setFavoriteImage(isFavorite: self.isFavorite)
    }
    
    func styleStarImage() {
        starButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        starButton.tintColor = UIColor(named: "custom_gold")
        starButton.setImage(nonFilledStar, for: .normal)
        starButton.setTitle(nil, for: .normal)
    }
    
    func setFavoriteImage(isFavorite: Bool) {
        if(isFavorite) {
            starButton.setImage(self.tintedFilledStar, for: .normal)
        } else {
            starButton.setImage(self.nonFilledStar, for: .normal)
        }
    }
    
    @objc func addFavorite(_ sender: UIButton) {
        
        if(!isFavorite) {
            setAsFavorite()
        } else {
            deleteFavorite()
        }
        
        onStaredChanged?()
        isFavorite = !isFavorite
        setFavoriteImage(isFavorite: isFavorite)
    }
    
    func deleteFavorite() {
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequestSingle(trackId: self.trackId!)
        var trackToBeDeleted: FavoriteTrack?
        
        do {
            trackToBeDeleted = try (context?.fetch(fetchRequest))!.first
        } catch let nsError as NSError {
            print("Could not fetch: \(nsError)")
        } catch {
            print("Something else went wrong")
        }
        
        self.context?.delete(trackToBeDeleted!)
        
        do {
            try context?.save()
        } catch let nsError as NSError {
            print("Could not delete: \(nsError)")
        }

    }
    
    func setAsFavorite() {
        let favoriteTrack = FavoriteTrack(context: self.context!)
        favoriteTrack.duration = trackDuration?.text
        favoriteTrack.trackName = trackName?.text
        favoriteTrack.orderId = orderId!
        favoriteTrack.trackId = trackId
        favoriteTrack.artistName = artistName
        
        do {
            try context?.save()
            setFavoriteImage(isFavorite: self.isFavorite)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    func convertToTimestamp(time: Int) -> String {
        let time = (minutes: (time / 1000) % 60, seconds: ((time / 1000) % 3600) / 60)
        var seconds = String(time.seconds)
        var minutes = String(time.minutes)
        if(time.seconds < 10) {
            seconds = "0" + seconds
        }
        
        if(time.minutes < 10) {
            minutes = "0" + minutes
        }
        
        return "(\(seconds):\(minutes))"
    }
}
