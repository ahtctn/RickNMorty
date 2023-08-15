//
//  ResultLocationModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import Foundation

struct ResultLocationModel: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
