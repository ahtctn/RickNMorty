//
//  Endpoints.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import Foundation
//
//  Endpoints.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 31.07.2023.
//

import Foundation

protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    func request() -> URLRequest
}

enum Endpoint<T: Decodable> {
    case getCharacters
    case getEpisodes
    case custom(url: String)
}

extension Endpoint: EndpointProtocol {
    var baseURL: String {
        return Constants.baseURL
    }
    
    var path: String {
        switch self {
        case .getCharacters:
            return Constants.pathCharacters
        case .getEpisodes:
            return Constants.pathEpisodes
        case .custom(url: let url):
            return url
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    func request() -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else { fatalError("baseurlerror")}
        //components.path = path
        print("\(components.url) URLsdlkfjsdlkfj")
        
        if let parameters = parameters {
            components.queryItems = parameters.map({ key, value in
                URLQueryItem(name: key, value: "\(value)")
            })
        }
        
        guard let url = components.url else { fatalError("url error")}
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let header = headers {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}
