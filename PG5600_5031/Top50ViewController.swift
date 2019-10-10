//
//  Top50ViewController.swift
//  PG5600_5031
//
//  Created by Marcus Jøsendal on 10/10/2019.
//  Copyright © 2019 Marcus Jøsendal. All rights reserved.
//

import Foundation
import UIKit

class Top50ViewController : UIViewController {
    @IBOutlet weak var topNav: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopAlbums()
    }
    
    @IBAction func myButton(_ sender: UIButton) {
        if let VC = (self.storyboard?.instantiateViewController(withIdentifier: "AlbumDetailViewController")) as? AlbumDetailViewController
        {
            VC.albumKey = "123"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func fetchTopAlbums() -> String {
        let urlSession = URLSession.shared
        let url = URL.init(string: "https://jsonplaceholder.typicode.com/todos/1")!
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let data = data {
                // This line so I can read the line
                // let responseString = String.init(data: data, encoding: String.Encoding.utf8)
                let decoder = JSONDecoder.init()
                
                // Actually decoding
                let todoObject = try! decoder.decode(Todo.self, from: data)
                
                // Update UI - have to do this on main thread
                DispatchQueue.main.async {
                    self.jsonLabel.text = todoObject.title
                }
                
            } else if let error = error {
                print(error)
            }
        }
        
        task.resume()
    }
}
