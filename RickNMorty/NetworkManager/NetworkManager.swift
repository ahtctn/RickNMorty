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
        request(endpoint, completion: completion)
    }
    
    func getEpisodes(completion: @escaping NetworkCompletion<EpisodesModel>) {
        let endpoint = Endpoint<EpisodesModel>.getEpisodes
        
        request(endpoint, completion: completion)
    }
    
    func getCharacterFromEpisode(url: String, completion: @escaping NetworkCompletion<ResultsModel>) {
        guard let url = URL(string: url.replacingOccurrences(of: Constants.baseURL, with: "")) else {
            print("Get character from episode url is wrong now")
            completion(.failure(.invalidURL))
            return
        }
        
        let endpoint = Endpoint<ResultsModel>.custom(url: url.absoluteString)
        request(endpoint, completion: completion)
    }
    
    func getEpisodesFromCharacter(url: String, completion: @escaping NetworkCompletion<ResultEpisodesModel>) {
        guard let url = URL(string: url.replacingOccurrences(of: Constants.baseURL, with: "")) else {
            print("Get character from episode url is wrong now.")
            completion(.failure(.invalidURL))
            return
        }
        
        let endpoint = Endpoint<ResultEpisodesModel>.custom(url: url.absoluteString)
        request(endpoint, completion: completion)
    }
    
    func getOtherPagesEpisodes(url: String, completion: @escaping NetworkCompletion<EpisodesModel>) {
        guard let url = URL(string: url.replacingOccurrences(of: Constants.baseURL, with: "")) else {
            print("Get upper page url is wrong now")
            completion(.failure(.invalidURL))
            return
        }
        
        let endpoint = Endpoint<EpisodesModel>.custom(url: url.absoluteString)
        request(endpoint, completion: completion)
    }
    
    func getOtherPagesCharacter(url: String, completion: @escaping NetworkCompletion<CharactersModel>) {
        guard let url = URL(string: url.replacingOccurrences(of: Constants.baseURL, with: "" )) else {
            print("Get upper page url is wrong now.")
            completion(.failure(.invalidURL))
            return
        }
        
        let endpoint = Endpoint<CharactersModel>.custom(url: url.absoluteString)
        request(endpoint, completion: completion)
    }
    
    
}
