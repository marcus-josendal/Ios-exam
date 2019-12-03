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
    
    /* CoreData */
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil
    var favoriteTracks: NSEntityDescription? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.context = appDelegate.persistentContainer.viewContext
        self.favoriteTracks = NSEntityDescription.entity(forEntityName: "FavoriteTrack", in: context!)
        
        
        styleIconImage()
        checkIfFavorite()
        self.isFavorite = true
        starButton.tintColor = UIColor(named: "custom_gold")
    }
    
    func styleIconImage() {
        starButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        starButton.setImage(nonFilledStar, for: .normal)
        starButton.setTitle(nil, for: .normal)
    }
    
    func checkIfFavorite() {
        // self.isSelected = true
    }
    
    @objc func addFavorite(_ sender: UIButton) {
        let favoriteTrack = FavoriteTrack(context: self.context!)
        favoriteTrack.duration = trackDuration?.text
        favoriteTrack.trackName = trackName?.text
        favoriteTrack.duration = "(04:50)"
        favoriteTrack.orderId = 0
        favoriteTrack.trackId = "87233287"
        
        do {
            try context?.save()
        } catch let error as NSError {
            print(error)
        }
        
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
        var rows: [FavoriteTrack] = []
        do {
            rows = try (context?.fetch(fetchRequest))!
        } catch {
            print("error")
        }
        
        rows.forEach {row in
            print(row.trackName)
        }
        
        
        self.isFavorite = !self.isFavorite
        if(self.isFavorite) {
            starButton.setImage(self.tintedFilledStar, for: .normal)
        } else {
            starButton.setImage(self.nonFilledStar, for: .normal)
        }
    }
    
    func setFavoriteImage() {
        
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
