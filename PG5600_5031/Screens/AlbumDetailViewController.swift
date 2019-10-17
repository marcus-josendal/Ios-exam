//
//  AlbumDetailViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 10/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var album: Album?
    var tracks = [Track]()
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var tracksTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch data related to album
        fetchTracks { (res) in
            switch res {
            case .success(let tracks):
                self.tracks = tracks
                self.fetchAlbumCoverImage()
                DispatchQueue.main.async {
                    self.tracksTable.reloadData()
                }
            case .failure(let err):
                print("Failed to fetch tracks", err)
            }
        }
        
        // Styling and giving UI-components data
        albumCover.image = UIImage(named: "album-placeholder")
        albumName.text = self.album!.strAlbum
        albumName.font = UIFont.boldSystemFont(ofSize: 25.0)
        albumArtist.text = "Released by " + self.album!.strArtist + " in " + self.album!.intYearReleased

    }
    
    fileprivate func fetchTracks(completion: @escaping (Result<[Track], Error>) -> ()) {
        let urlString = "https://theaudiodb.com/api/v1/json/1/track.php?m=" + self.album!.idAlbum
        guard let url = URL(string: urlString) else { return }
        
        // Fetches album-JSON data
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                completion(.failure(err))
            }
            
            do {
                let trackResponse = try JSONDecoder().decode(TracksResponse.self, from: data!)
                completion(.success(trackResponse.track))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    func fetchAlbumCoverImage() {
        if let url = URL(string: (self.album!.strAlbumThumb)) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    DispatchQueue.main.async {
                        self.albumCover.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    /* METHODS FOR TRACKS TABLE VIEW BELOW */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)
        return cell
    }
}
