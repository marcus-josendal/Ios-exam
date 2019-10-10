//
//  Top50ViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 10/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class Top50ViewController : UITableViewController {
    @IBOutlet weak var topNav: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController styling
        navigationItem.title = "Top 50 Albums"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(named: "lightBlack")
        
        print(fetchTopAlbums())
    }
    
    
    func fetchTopAlbums() -> [Album] {
        let urlSession = URLSession.shared
        let url = URL.init(string: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")!
        var albums: [Album]? = nil
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            do {
                let decoder = JSONDecoder.init()
                let todoObject = try decoder.decode(LovedResponse.self, from: data!)
                albums = todoObject.loved
            } catch {
                print(error)
            }
        }
        task.resume()
        return albums ?? []
    }
}
