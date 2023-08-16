//
//  LocationsDetailViewModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import Foundation

class LocationsDetailViewModel {
    var eventHandler: ((_ event: Event) -> Void)?
    private var locationCharacterUrls: [String] = []
    var charcters: [ResultsCharactersModel] = []
    
    func getCharactersInLocation(with urls: [String]) {
        self.eventHandler?(.loading)
        
        var characters: [ResultsCharactersModel] = []
        self.locationCharacterUrls = urls
        
        let dispatchGroup = DispatchGroup()
        
        for characterUrl in urls {
            dispatchGroup.enter()
            
            NetworkManager.shared.getCharacterFromLocation(url: characterUrl) { result in
                switch result {
                case .success(let character):
                    characters.append(character)
                case .failure(let error):
                    print("\(error.localizedDescription) get characters error in LocationsDetailViewModel class.")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.charcters = characters
            self.eventHandler?(.dataLoaded)
        }
    }
    
    func numberOfRows() -> Int {
        return self.charcters.count
    }
    
    func resultCell(at index: Int) -> ResultsCharactersModel {
        return self.charcters[index]
    }
}

extension LocationsDetailViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ error: Error?)
    }
}
