//
//  InfoModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import Foundation

struct InfoModel: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
