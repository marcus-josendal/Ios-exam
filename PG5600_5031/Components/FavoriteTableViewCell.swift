//
//  FavoriteTrackCell.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 05/12/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class FavoriteTableViewCell : UITableViewCell {
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

