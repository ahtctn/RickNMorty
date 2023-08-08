//
//  InfoEpisodesModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 7.08.2023.
//

import Foundation

// MARK: - Info
struct InfoEpisodesModel: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
