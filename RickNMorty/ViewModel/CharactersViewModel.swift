//
//  CharactersViewModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
// 

import Foundation

class CharactersViewModel {
    var characters: [ResultsModel] = []
    var eventHandler:((_ event: Event) -> Void)?
    
    private var nextPageUrl: String?
    private var prevPageUrl: String?
    
    func getCharacters() {
        self.eventHandler?(.loading)
        NetworkManager.shared.getCharacters { results in
            switch results {
            case .success(let characters):
                self.characters = characters.results
                self.nextPageUrl = characters.info.next
                self.eventHandler?(.dataLoaded)
                print(characters.info.next)
            case .failure(let error):
                print(error.localizedDescription)
                print("na bura")
            }
        }
    }
    
    func numberOfRows() -> Int {
        return self.characters.count
    }
    
    func resultCell(at index: Int) -> ResultsModel {
        return self.characters[index]
    }
    
    func getNextPage() {
        guard let nextPageUrl = self.nextPageUrl else {
            print("No next page url")
            return
        }
        
        self.eventHandler?(.loading)
        NetworkManager.shared.getOtherPages(url: nextPageUrl) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters.append(contentsOf: characters.results)
                self?.nextPageUrl = characters.info.next
                self?.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error.localizedDescription)
                self?.eventHandler?(.error(error))
            }
        }
    }
    
    func getPrevPage() {
        guard let prevPageUrl = self.prevPageUrl else {
            print("no prev page url")
            return
        }
        
        self.eventHandler?(.loading)
        NetworkManager.shared.getOtherPages(url: prevPageUrl) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters.append(contentsOf: characters.results)
                self?.prevPageUrl = characters.info.prev
                self?.eventHandler?(.dataLoaded)
            case .failure(let error):
                print("\(error.localizedDescription) prev page error")
                self?.eventHandler?(.error(error))
            }
        }
    }
    
}

extension CharactersViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ error: Error?)
    }
}
