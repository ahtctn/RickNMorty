//
//  CharactersModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import Foundation

// MARK: - CharactersModel
struct CharactersModel: Codable {
    let info: InfoModel
    let results: [ResultsModel]
}
