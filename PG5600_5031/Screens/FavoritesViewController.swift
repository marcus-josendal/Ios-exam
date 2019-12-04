//
//  FavoritesViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 03/12/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewController : UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil
    var favoriteTracksEntity: NSEntityDescription? = nil
    var favoriteTracks = [FavoriteTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationController styling
        navigationItem.title = "Favorite Tracks"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(named: "lightBlack")
        
        self.context = appDelegate.persistentContainer.viewContext
        self.favoriteTracksEntity = NSEntityDescription.entity(forEntityName: "FavoriteTrack", in: context!)
        self.tableView.dragInteractionEnabled = true
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
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteTracks.count
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath)
        print(destinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String("\(self.favoriteTracks[indexPath.row].orderId) - \(self.favoriteTracks[indexPath.row].trackName)")
        return cell
    }
}
