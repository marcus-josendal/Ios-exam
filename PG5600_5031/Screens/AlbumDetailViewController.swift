//
//  AlbumDetailViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 10/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailViewController : UIViewController {
    var album: Album?
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        myLabel.text = album?.strAlbum
        print(self.album)
        super.viewDidLoad()
    }
}
