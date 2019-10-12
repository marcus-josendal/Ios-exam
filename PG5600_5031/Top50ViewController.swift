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
    @IBOutlet var albumTableView: UITableView!
    @IBOutlet weak var topNav: UINavigationItem!
    private var albums = [Album]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController styling
        navigationItem.title = "Top 50 Albums"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(named: "lightBlack")
        
        // Fetch JSON and reload the tableview
        fetchTopAlbums { (res) in
            switch res {
            case .success(let albums):
                self.albums = albums
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let err):
                print("Failed to fetch albums", err)
            }
        }
    }
    
    /*
        Fetches top 50 albums from API. To implement handle callback given from method.
    */
    fileprivate func fetchTopAlbums(completion: @escaping (Result<[Album], Error>) -> ()) {
        let urlString = "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            do {
                let albums = try JSONDecoder().decode(LovedResponse.self, from: data!)
                completion(.success(albums.loved))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
        cell.textLabel?.text = self.albums[indexPath.row].strArtist
        return cell
    }
}
