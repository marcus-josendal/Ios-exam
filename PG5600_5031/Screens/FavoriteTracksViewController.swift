//
//  FavoriteTracksViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 04/12/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteTracksViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil
    var favoriteTracksEntity: NSEntityDescription? = nil
    var favoriteTracks = [FavoriteTrack]()
    var recommendations: [String] = []
    @IBOutlet weak var favoriteTracksTableView: UITableView!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Navigation Controller styling */
        navigationItem.title = "Favorite Tracks"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(named: "lightBlack")
        
        /* Sets delegates and datasources */
        favoriteTracksTableView.delegate = self
        favoriteTracksTableView.dataSource = self
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        
        /* Initialize CoreData */
        self.context = appDelegate.persistentContainer.viewContext
        self.favoriteTracksEntity = NSEntityDescription.entity(forEntityName: "FavoriteTrack", in: context!)
        self.favoriteTracksTableView.dragInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavoriteTracks()
        updateRecommendations()
    }
    
    /* Returns array of persisted tracks that the user has favorited */
    func getFavoriteTracks() {
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequest()
        do {
            favoriteTracks = try (context?.fetch(fetchRequest))!
        } catch let nsError as NSError {
            print("Could not fetch: \(nsError)")
        } catch {
            print("Something else went wrong")
        }
        
        DispatchQueue.main.async {
            self.favoriteTracksTableView.reloadData()
        }
    }
    
    /* TABLE VIEW RELATED FUNCTIONALITY FOR FAVORITE TRACKS BELOW */
    
    /*
        In addition to delete cells in "edit"-mode this enables swipe delete when not in edit mode.
        Result of deletion is persisted in database.
    */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let alertController = UIAlertController(title: "Delete Track", message: "Are you sure you want to delete this track?", preferredStyle: .alert)
            
            let deleteTrackAction = UIAlertAction(title: "Delete", style: .default) { (action:UIAlertAction!) in
                self.context?.delete(self.favoriteTracks[indexPath.row])
                self.favoriteTracks.remove(at: indexPath.row)
                self.favoriteTracksTableView.deleteRows(at: [indexPath], with: .fade)
                
                do {
                    try self.context?.save()
                    self.updateRecommendations()
                } catch let nsError as NSError {
                    print("Could not delete: \(nsError)")
                }
            }
            
            let cancelDeletionAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
                return
            }
            
            alertController.addAction(deleteTrackAction)
            alertController.addAction(cancelDeletionAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /* Enabled or disables editing mode in Tableview based on editButton state */
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        favoriteTracksTableView.isEditing = !favoriteTracksTableView.isEditing
         sender.title = favoriteTracksTableView.isEditing ? "Done" : "Edit"
    }
    
    /* Re-orders the lists of tracks based on how the cell is moved */
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let start = fromIndexPath.row
        let end = to.row
        
        let moveItem = favoriteTracks[start]
        favoriteTracks.remove(at: start)
        favoriteTracks.insert(moveItem, at: end)
        func reOrder (startIndex: Int, endIndex: Int) -> Void  {
            for index in stride(from: startIndex, through: endIndex, by: 1) {
                favoriteTracks[index].orderId = Int32(index)
                updateTrackOrderId(track: favoriteTracks[index])
            }
        }
        
        moveItem.orderId = Int32(end)
        updateTrackOrderId(track: moveItem)
        
        if(start > end) {
            reOrder(startIndex: end + 1, endIndex: start)
        }
        
        if(start < end) {
            reOrder(startIndex: start, endIndex: end - 1)
        }
    }
    
    /* Updates the OrderId for the track where the trackId equals input track id */
    func updateTrackOrderId(track: FavoriteTrack) {
        
        let fetchRequest: NSFetchRequest<FavoriteTrack> = FavoriteTrack.fetchRequestSingle(trackId: track.trackId!)

        do {
            let favorites = try context!.fetch(fetchRequest)
            let objectToUpdate: NSManagedObject = favorites.first!
            objectToUpdate.setValue(track.orderId, forKey: "orderId")
            do{
                try context!.save()
            }
            catch let error as NSError {
                print("Coult not update track: \(error)")
            }
        } catch let error as NSError {
            print("Could not fetch track: \(error)")
        }
    }
    
    
    
    
    /* Returns a cell with track data from persisted favorite tracks */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTracksTableView.dequeueReusableCell(withIdentifier: "FavoriteTrackCell") as? FavoriteTableViewCell
        let cellData = favoriteTracks[indexPath.row]
        cell?.trackName.text = cellData.trackName
        cell?.artistName.text = cellData.artistName
        cell?.trackDuration.text = cellData.duration
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTracks.count
    }
    
    /* COLLECTION VIEW RELATED FUNCTIONALITY FOR SUGGESTIONS BELOW */
    
    /* When recommendations data is fetched update the recomendations field */
    func updateRecommendations() {
        getRecommendationsData { (res) in
            switch res {
            case .success(let recommendations):
                self.recommendations = recommendations.Similar.Results.map{ recommendation in recommendation.Name }
                DispatchQueue.main.async {
                    self.suggestionsCollectionView.reloadData()
                }
            case .failure(let err):
                print("Failed to fetch albums", err)
            }
        }
    }
    
    /* Fetches recommendations data from the TasteDive-API based on the artists in the favoriteTracks field */
    fileprivate func getRecommendationsData(completion: @escaping (Result<Recommendations, Error>) -> ()) {
        let artistsFromTracks = Set(favoriteTracks.map{ track in
            return track.artistName?.replacingOccurrences(of: " ", with: "+").lowercased()
        })
        
        if(artistsFromTracks.count != 0) {
            let artistParams = Array(artistsFromTracks).compactMap{ $0 }.joined(separator: ",")
            let urlString = "https://tastedive.com/api/similar?q=\(artistParams)&type=music&k=350751-MusicApp-YGW1T8WB"
            
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                if let err = err { completion(.failure(err)) }
                
                do {
                    let recommendations = try JSONDecoder().decode(Recommendations.self, from: data!)
                    completion(.success(recommendations))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }.resume()
        }
    }
    
    /* Returns a CollectionViewCell with name of artist in the recommendations field */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = suggestionsCollectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestionsCollectionViewCell
        cell?.artistName.text = recommendations[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
}
