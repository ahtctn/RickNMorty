//
//  ResultEpisodesModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 7.08.2023.
//

import Foundation

// MARK: - Result
struct ResultEpisodesModel: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
