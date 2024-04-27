//
//  ViewController.swift
//  VideoGames
//
//  Created by Yusuf Süer on 23.04.2024.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var TableView: UITableView!
    
    var results = [Results]()
    var filteredResults = [Results]()
    var searching : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBar.delegate = self
        fetchGames(URL: "https://api.rawg.io/api/games?key=164ee4be1ef74366a4b14f6898c37958") { result in
            self.results = result.results
            DispatchQueue.main.async {
                self.TableView.reloadData()
            }
           
        }
    
         
             
    }
    
    func fetchGames(URL url:String, completion: @escaping (Game) -> Void) {
        
        let url = URL(string: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            if data != nil && error == nil {
                do {
                    let parsingData = try JSONDecoder().decode(Game.self, from: data!)
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

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !searching {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                vc.id = results[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                vc.id = filteredResults[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searching {
            return results.count
            
        } else {
            return filteredResults.count
        }
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if !searching {
            
            cell?.textLabel?.text = results[indexPath.row].name
            cell?.detailTextLabel?.text = "Rating: \(results[indexPath.row].rating)"
         
            
            if let url = URL(string: results[indexPath.row].backgroundImage) {
                cell?.imageView?.downloaded(from: url) // Asenkron resim yükleme
                cell?.imageView?.contentMode = .scaleAspectFit
                        // Opsiyonel olarak resmin frame'ini de ayarlayabilirsiniz
                cell?.imageView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50) // Örnek değerler
                cell?.imageView?.clipsToBounds = true
               }
        } else {
           
            cell?.textLabel?.text = filteredResults[indexPath.row].name
            cell?.detailTextLabel?.text = "Rating: \(filteredResults[indexPath.row].rating)"
         
            
            if let url = URL(string: filteredResults[indexPath.row].backgroundImage) {
                cell?.imageView?.downloaded(from: url) // Asenkron resim yükleme
                cell?.imageView?.contentMode = .scaleAspectFit
                        // Opsiyonel olarak resmin frame'ini de ayarlayabilirsiniz
                cell?.imageView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50) // Örnek değerler
                cell?.imageView?.clipsToBounds = true
               }
        }
        
      
        
       
        
        return cell!
    }

    
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("changed")
        if searchText.count < 3 {
            filteredResults = results
        } else {
            filteredResults = results.filter{$0.name.range(of: searchText, options: .caseInsensitive) != nil}
        }
        
        searching = true
        TableView.reloadData()
    }
}
