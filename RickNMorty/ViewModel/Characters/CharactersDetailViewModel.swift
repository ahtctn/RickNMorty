//
//  CharactersDetailViewModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 10.08.2023.
//

import Foundation

class CharactersDetailViewModel {
    var eventHandler: ((_ event: Event) -> Void)?
    var characterEpisodeUrls: [String] = []
    var episodes: [ResultEpisodesModel] = []
    
    func getEpisodesInCharacter(with urls: [String]) {
        self.eventHandler?(.loading)
        
        var episodes: [ResultEpisodesModel] = []
        self.characterEpisodeUrls = urls
        
        let dispatchGroup = DispatchGroup()
        
        for episodeUrl in urls {
            dispatchGroup.enter()
            
            NetworkManager.shared.getEpisodesFromCharacter(url: episodeUrl) { result in
                switch result {
                case .success(let episode):
                    episodes.append(episode)
                case .failure(let error):
                    print("\(error.localizedDescription) Get episodes error in CharactersDetailViewModel class")
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.episodes = episodes
            self.eventHandler?(.dataLoaded)
        }
    }
    
    func numberOfRows() -> Int {
        self.episodes.count
    }
    
    func resultCell(at index: Int) -> ResultEpisodesModel {
        return self.episodes[index]
    }
}

extension CharactersDetailViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ error: Error?)
    }
}
