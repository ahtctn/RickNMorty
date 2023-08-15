//
//  InfoLocationModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import Foundation

// MARK: - Info
struct InfoLocationModel: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
