//
//  DetailAlbumViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 23/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class DetailAlbumViewController : UITableViewController {
    var album: Album?
    var tracks = [Track]()
    @IBOutlet var tracksTable: UITableView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumInfo: UILabel!
    @IBOutlet weak var albumReleaseYear: UILabel!
    
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
        self.albumCover.image = UIImage(named: "album-placeholder")
        self.albumInfo?.text = album?.strAlbum
        self.albumReleaseYear?.text = album?.intYearReleased
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
        if let url = URL(string: (self.album!.strAlbumThumb ?? "")) {
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "trackHeadlineCell", for: indexPath)
            firstCell.textLabel?.text = "Album Tracks"
            firstCell.textLabel?.textColor = .white
            firstCell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            return firstCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackTableViewCell
        cell.trackName.text = self.tracks[indexPath.row].strTrack
        
        cell.trackDuration.text = cell.convertToTimestamp(time: Int(self.tracks[indexPath.row].intDuration)!)
        return cell
    }
}
