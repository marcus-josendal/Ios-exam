//
//  DetailAlbumViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 23/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DetailAlbumViewController : UITableViewController {

    /* UI */
    @IBOutlet var tracksTable: UITableView!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumInfo: UILabel!
    @IBOutlet weak var albumReleaseYear: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    /* CoreData */
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil
    var favoriteTracksEntity: NSEntityDescription? = nil
    
    /* Other Fields */
    var album: Album?
    var tracks = [Track]()
    var favoriteTracks = [FavoriteTrack]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Initialize Core Data */
        self.context = appDelegate.persistentContainer.viewContext
        self.favoriteTracksEntity = NSEntityDescription.entity(forEntityName: "FavoriteTrack", in: context!)
        
        /* Fetches persisted favorite tracks and tracks for given album */
        getFavoriteTracks()
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
        
        /* Sets data sent from the top 50 table view controller */
        self.albumCover.image = UIImage(named: "album-placeholder")
        self.albumInfo?.text = album?.strAlbum
        self.albumReleaseYear?.text = "\(album!.intYearReleased) - \(album!.strArtist)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavoriteTracks()
        tracksTable.reloadData()
    }
    
    /*
        Fetches tracks where album-id matches the one sent from the top 50 view controller
        Returns a response in form of an array of Tracks.
    */
    fileprivate func fetchTracks(completion: @escaping (Result<[Track], Error>) -> ()) {
        let urlString = "https://theaudiodb.com/api/v1/json/1/track.php?m=" + album!.idAlbum
        guard let url = URL(string: urlString) else { return }
        
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
    
    /* Fetches persisted tracks and sets them to the favoriteTracks field */
    func getFavoriteTracks() {
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
        do {
            favoriteTracks = try (context?.fetch(fetchRequest))!
        } catch let nsError as NSError {
            print("Could not fetch: \(nsError)")
        } catch {
            print("Something else went wrong")
        }
    }
    
    /* Fetches image-data for the album-cover and sets data to field albumCover */
    func fetchAlbumCoverImage() {
        if(self.album!.strAlbumThumb != nil) {
        if let url = URL(string: (self.album!.strAlbumThumb!)) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                if let data = data {
                    DispatchQueue.main.async {
                        self.albumCover.image = UIImage(data: data)
                    }
                }
            }
        }
        }}
    
    /*
        If it is the first row, style it to make it look like a headline.
        If not send all the data necessary to the TrackTableViewCell to make
        it possible to persist the tracks.
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "trackHeadlineCell", for: indexPath)
            firstCell.textLabel?.text = "Album Tracks"
            firstCell.textLabel?.textColor = .white
            firstCell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
            return firstCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackTableViewCell
        let trackData = tracks[indexPath.row]
        cell.orderId = Int32(favoriteTracks.count)
        cell.trackId = trackData.idTrack
        cell.artistName = trackData.strArtist
        cell.trackName.text = trackData.strTrack
        cell.trackDuration.text = Time().convertToTimestamp(time: Int(trackData.intDuration)!)
        cell.isFavorite = self.favoriteTracks.contains(where: { $0.trackName == trackData.strTrack })
        cell.onStaredChanged = {
            self.getFavoriteTracks()
            self.tracksTable.reloadData()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 40
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
}
