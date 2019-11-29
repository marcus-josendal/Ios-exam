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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
