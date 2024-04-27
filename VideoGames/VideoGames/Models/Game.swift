//
//  Game.swift
//  VideoGames
//
//  Created by Yusuf Süer on 25.04.2024.
//



import Foundation

struct Game : Codable {
    let results: [Results]
}

struct Results : Codable {
    let id: Int
    let name: String
    let backgroundImage: String
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id, name
        case backgroundImage = "background_image"
        case rating
    }
}
