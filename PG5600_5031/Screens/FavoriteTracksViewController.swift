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
        
        navigationItem.title = "Favorite Tracks"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(named: "lightBlack")
        
        favoriteTracksTableView.delegate = self
        favoriteTracksTableView.dataSource = self
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
        
        self.context = appDelegate.persistentContainer.viewContext
        self.favoriteTracksEntity = NSEntityDescription.entity(forEntityName: "FavoriteTrack", in: context!)
        self.favoriteTracksTableView.dragInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavoriteTracks()
    }
    
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
        
        updateRecommendations()
    }
    
    
    /* TABLE VIEW RELATED FUNCTIONALITY FOR FAVORITE TRACKS BELOW */
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            context?.delete(favoriteTracks[indexPath.row])
            favoriteTracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try context?.save()
            } catch let nsError as NSError {
                print("Could not delete: \(nsError)")
            }
        }
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        favoriteTracksTableView.isEditing = !favoriteTracksTableView.isEditing
         sender.title = favoriteTracksTableView.isEditing ? "Done" : "Edit"
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        updateTrack(start: sourceIndexPath.row, end: destinationIndexPath.row)
    }
    
    func updateTrack(start: Int, end: Int) {
        favoriteTracksTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String("\(self.favoriteTracks[indexPath.row].orderId) - \(self.favoriteTracks[indexPath.row].trackName)")
        return cell
    }
    
    /* COLLECTION VIEW RELATED FUNCTIONALITY FOR SUGGESTIONS BELOW */
    
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
    
    fileprivate func getRecommendationsData(completion: @escaping (Result<TasteDiveResponse, Error>) -> ()) {
        
        let artistsFromTracks = Set(favoriteTracks.map{ track in
            return track.artistName?.replacingOccurrences(of: " ", with: "+").lowercased()
        })
        
        let artistParams = Array(artistsFromTracks).compactMap{ $0 }.joined(separator: ",")
        let urlString = "https://tastedive.com/api/similar?q=\(artistParams)&type=music&k=350751-MusicApp-YGW1T8WB"
        
        guard let url = URL(string: urlString) else { return }
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err { completion(.failure(err)) }
            
            do {
                let recommendations = try JSONDecoder().decode(TasteDiveResponse.self, from: data!)
                completion(.success(recommendations))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = suggestionsCollectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCell", for: indexPath) as? SuggestionsCollectionViewCell
        cell?.artistName.text = recommendations[indexPath.row]
        return cell!
    }
}
