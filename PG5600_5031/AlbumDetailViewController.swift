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
    var albumKey = ""
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        myLabel.text = albumKey
    }
}
