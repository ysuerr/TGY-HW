//
//  GameDetail.swift
//  VideoGames
//
//  Created by Yusuf Süer on 26.04.2024.
//

import Foundation

struct GameDetail : Codable {
    let id: Int
     let name, description: String
     let metacritic: Int
    let released, backgroundImage: String

       enum CodingKeys: String, CodingKey {
           case id, name, description, metacritic, released
           case backgroundImage = "background_image"
       }
}


