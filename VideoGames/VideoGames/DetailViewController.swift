//
//  DetailViewController.swift
//  VideoGames
//
//  Created by Yusuf Süer on 26.04.2024.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var PosterImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ReleaseDateLabel: UILabel!
    @IBOutlet weak var MetacriticLabel: UILabel!
    @IBOutlet weak var DescriptionTextView: UITextView!
    var id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchGamesDetail(URL: "https://api.rawg.io/api/games/\(id)?key=164ee4be1ef74366a4b14f6898c37958") { result in
            
            DispatchQueue.main.async {
                self.NameLabel.text = "Name: "+result.name
                self.ReleaseDateLabel.text = "Release Date: "+result.released
                self.MetacriticLabel.text = "Metacritic: "+String(result.metacritic)
                let url = URL(string: result.backgroundImage)
                self.PosterImageView.downloaded(from: url! )
                self.DescriptionTextView.text = result.description
                
            }
        }
            
    }
    

    
    func fetchGamesDetail(URL url:String, completion: @escaping (GameDetail) -> Void) {
        print(url)
        let url = URL(string: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            if data != nil && error == nil {
                do {
                    let parsingData = try JSONDecoder().decode(GameDetail.self, from: data!)
                    completion(parsingData)
                    //print(parsingData)
                    
                } catch {
                    print("parsing error: ",error)
                   
                }
            }
        }
        dataTask.resume()
        
    }

}
