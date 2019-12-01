//
//  TrackTableViewCell.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 23/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class TrackTableViewCell : UITableViewCell {
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    let nonFilledStar = UIImage(named: "icons8-star")?.withRenderingMode(.alwaysTemplate)
    let tintedFilledStar = UIImage(named: "icons8-star_filled")?.withRenderingMode(.alwaysTemplate)
    var isFavorite: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkIfFavorite()
        self.isFavorite = true
        starButton.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        starButton.setImage(nonFilledStar, for: .normal)
        starButton.setTitle(nil, for: .normal)
        starButton.tintColor = UIColor(named: "custom_gold")
    }
    
    func checkIfFavorite() {
        // self.isSelected = true
    }
    
    @objc func addFavorite(_ sender: UIButton) {
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
