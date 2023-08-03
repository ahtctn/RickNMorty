//
//  ServiceError.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import Foundation

enum ServiceError: Error {
case invalidURL
case invalidResponse
case invalidData
case decodingError( _ error: Error)
}
