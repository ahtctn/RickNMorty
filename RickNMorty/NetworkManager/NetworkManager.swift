//
//  NetworkManager.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import Foundation

typealias NetworkResult<T: Decodable> = Result<T, ServiceError>
typealias NetworkCompletion<T: Decodable> = (NetworkResult<T>) -> Void

class NetworkManager {
    static let shared = NetworkManager()
    
    private init () {}
    
    private func request<T: Decodable>(_ endpoint: Endpoint<T>, completion: @escaping NetworkCompletion<T>) {
        let task = URLSession.shared.dataTask(with: endpoint.request()) { data, response, error in
            guard let data = data, error == nil else {
                print("URLSession Error: \(String(describing: error))")
                completion(.failure(.invalidData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Invalid HTTP Response Status Code: \(httpResponse.statusCode)")
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
                completion(.failure(.decodingError(error)))
            }
            
            
        }
        task.resume()
    }
    
    func getCharacters(completion: @escaping NetworkCompletion<CharactersModel>) {
        let endpoint = Endpoint<CharactersModel>.getCharacters
        print(endpoint)
        request(endpoint, completion: completion)
    }
    
    func getEpisodes(completion: @escaping NetworkCompletion<CharactersModel>) {
        let endpoint = Endpoint<CharactersModel>.getEpisodes
        
        request(endpoint, completion: completion)
    }
    
    func getOtherPages(url: String, completion: @escaping NetworkCompletion<CharactersModel>) {
        guard let url = URL(string: url.replacingOccurrences(of: Constants.baseURL, with: "" )) else {
            print("Get upper page url yanlış")
            completion(.failure(.invalidURL))
            return
        }
        
        let endpoint = Endpoint<CharactersModel>.custom(url: url.absoluteString)
        print("\(endpoint)endpoint")
        request(endpoint, completion: completion)
    }
    
}
