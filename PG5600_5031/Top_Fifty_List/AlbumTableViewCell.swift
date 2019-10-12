//
//  AlbumTableViewCell.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 12/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class AlbumTableViewCell : UITableViewCell {
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumCoverImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
