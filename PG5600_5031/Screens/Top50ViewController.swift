//
//  Top50ViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 10/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class Top50ViewController : UITableViewController {
    @IBOutlet var albumTableView: UITableView!
    @IBOutlet weak var topNav: UINavigationItem!
    @IBOutlet weak var displaySwitch: UISegmentedControl!
    
    private var albums = [Album]()
    private var alternateCellView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* NavigationController styling */
        navigationItem.title = "Top 50 Albums"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(named: "lightBlack")

        
        /* Fetch JSON and reloads the tableview */
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
        
        /* Sets icons for the toggle-controller in the right corner */
        displaySwitch.setImage(UIImage(named: "icons8-list_2"), forSegmentAt: 0)
        displaySwitch.setImage(UIImage(named: "icons8-list"), forSegmentAt: 1)
    }
    
    /*
        Fetches the top 50 albums returned from theaudiodb-API.
        Returns a response in form of an array of Albums.
    */
    fileprivate func fetchTopAlbums(completion: @escaping (Result<[Album], Error>) -> ()) {
        let urlString = "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                let albums = try JSONDecoder().decode(LovedResponse.self, from: data!)
                completion(.success(albums.loved))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    /* Toggles between image-rows and a alternate row type */
    @IBAction func displayChanged(_ sender: Any) {
        self.alternateCellView = !alternateCellView
        self.tableView.rowHeight = alternateCellView ? 50 : 100
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    /*
        If alternateCellView is not toggled return image-cell type.
        If toggled return an alternate-cell type
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = self.albums[indexPath.row]
        if(!alternateCellView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell
            cell?.albumName.text = cellData.strAlbum
            cell?.artistName.text = cellData.strArtist
            
            cell?.albumCoverImage.kf.setImage(
                with: URL(string: cellData.strAlbumThumb ?? ""),
                placeholder: UIImage(named: "album-placeholder"),
                options: [.transition(.fade(0.5))],
                progressBlock: nil
            )
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "alternateAlbumCell", for: indexPath) as? AlternateAlbumTableViewCell
            cell?.albumName.text = "\(indexPath.row + 1). \(cellData.strAlbum)"
            cell?.artistName.text = cellData.strArtist
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    /*
        Navigates to the detail view for the given album.
        Sends with the album information so it is possible to limit
        the number of requests made in the Detail Table View to 1.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailAlbumViewController") as? DetailAlbumViewController
        vc?.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
