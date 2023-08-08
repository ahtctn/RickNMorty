//
//  ResultsModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import Foundation

// MARK: - Result
struct ResultsModel: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: LocationModel
    let image: String?
    let episode: [String]
    let url: String
    let created: String
}
