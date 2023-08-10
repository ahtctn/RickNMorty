//
//  EpisodesDetailViewModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 9.08.2023.
//

import Foundation

class EpisodesDetailViewModel {
    var eventHandler: ((_ event: Event) -> Void)?
    private var episodeCharacterUrls: [String] = []
    var characters: [ResultsModel] = []
    
    func getCharactersInEpisode(with urls: [String]) {
        self.eventHandler?(.loading)
        
        var characters: [ResultsModel] = [] // Boş bir dizi oluştur
        self.episodeCharacterUrls = urls // Değişiklik: URL'leri sakla
        
        let dispatchGroup = DispatchGroup() // DispatchGroup kullanarak her karakter için ayrı ayrı requestleri bekleteceğiz
        
        for characterUrl in urls { // ResultEpisodesModel içindeki characters dizisini dön
            dispatchGroup.enter() // DispatchGroup'a giriş yap
            
            NetworkManager.shared.getCharacterFromEpisode(url: characterUrl) { result in
                switch result {
                case .success(let character):
                    characters.append(character) // Karakteri diziye ekle
                case .failure(let error):
                    print("\(error.localizedDescription) Get Characters Error In EpisodesDetailViewModel class.")
                }
                
                dispatchGroup.leave() // DispatchGroup'tan çıkış yap
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // Tüm requestler tamamlandığında bu blok çalışacak
            self.characters = characters
            self.eventHandler?(.dataLoaded)
        }
    }
    
    func numberOfRows() -> Int {
        return self.characters.count
    }
    
    func resultCell(at index: Int) -> ResultsModel {
        return self.characters[index]
    }
}

extension EpisodesDetailViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ error: Error?)
    }
}
