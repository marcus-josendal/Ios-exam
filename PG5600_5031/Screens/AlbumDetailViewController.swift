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
    var tracks: [Track]?
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTracks { (res) in
            switch res {
            case .success(let tracks):
                self.tracks = tracks
                self.fetchAlbumCoverImage()
            case .failure(let err):
                print("Failed to fetch tracks", err)
            }
        }
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
        
    }
}
