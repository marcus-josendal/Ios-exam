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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
