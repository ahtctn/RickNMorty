//
//  LocationModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import Foundation

struct LocationModel: Codable {
    let info: InfoLocationModel
    let results: [ResultLocationModel]
}



