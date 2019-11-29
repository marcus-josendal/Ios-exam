//
//  SearchAlbumViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 28/11/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class SearchAlbumViewController : UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    private var albums = [Album]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        // NavigationController styling
        navigationItem.title = "Search for Album"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(named: "lightBlack")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count >= 2) {
            self.fetchTopAlbums(albumName: getFormattedAlbumName(albumName: searchText)) { (res) in
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
    }
    
    fileprivate func fetchTopAlbums(albumName: String, completion: @escaping (Result<[Album], Error>) -> ()) {
        let urlString = "https://theaudiodb.com/api/v1/json/1/searchalbum.php?a=&a=" + albumName
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                let albums = try JSONDecoder().decode(SearchResponse.self, from: data!)
                completion(.success(albums.album ?? []))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
            }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set album name and album artist
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as? AlbumTableViewCell
        let cellData = self.albums[indexPath.row]
        cell?.albumName.text = cellData.strAlbum
        cell?.artistName.text = cellData.strArtist
        
        // Sets the UITableView.image to the image from the API
        let url = cellData.strAlbumThumb
        cell?.albumCoverImage.kf.setImage(with: URL(string: url ?? ""), placeholder: UIImage(named: "album-placeholder"), options: [.transition(.fade(0.5))], progressBlock: nil)
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailAlbumViewController") as? DetailAlbumViewController
        vc?.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getFormattedAlbumName(albumName: String) ->  String {
        return albumName.replacingOccurrences(of: " ", with: "_").lowercased()
    }
}
