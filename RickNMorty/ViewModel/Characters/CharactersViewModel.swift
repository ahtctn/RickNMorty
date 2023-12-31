//
//  CharactersViewModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
// 

import Foundation

class CharactersViewModel {
    var characters: [ResultsCharactersModel] = []
    var filteredCharacters: [ResultsCharactersModel] = []
    
    var eventHandler:((_ event: Event) -> Void)?
    
    private var nextPageUrl: String?
    private var prevPageUrl: String?
    
    private var isNextPageUrlWarningShown: Bool = false
    private var isPrevPageUrlWarningShown: Bool = false
    
    func getCharacters() {
        self.eventHandler?(.loading)
        NetworkManager.shared.getCharacters { results in
            switch results {
            case .success(let characters):
                self.characters = characters.results
                self.nextPageUrl = characters.info?.next
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print("\(error.localizedDescription) Get Characters Error In CharactersViewModel class.")
            }
        }
    }
    
    func getNextPage() {
        guard let nextPageUrl = self.nextPageUrl else {
            showPrevNextPageUrlWarning()
            return
        }
        
        self.eventHandler?(.loading)
        NetworkManager.shared.getOtherPagesCharacter(url: nextPageUrl) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters.append(contentsOf: characters.results)
                self?.nextPageUrl = characters.info?.next
                self?.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error.localizedDescription)
                self?.eventHandler?(.error(error))
            }
        }
    }
    
    func getPrevPage() {
        guard let prevPageUrl = self.prevPageUrl else {
            showPrevNextPageUrlWarning()
            return
        }
        
        self.eventHandler?(.loading)
        NetworkManager.shared.getOtherPagesCharacter(url: prevPageUrl) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters.append(contentsOf: characters.results)
                self?.prevPageUrl = characters.info?.prev
                self?.eventHandler?(.dataLoaded)
            case .failure(let error):
                print("\(error.localizedDescription) prev page error")
                self?.eventHandler?(.error(error))
            }
        }
    }
    
    private func showPrevNextPageUrlWarning() {
        guard !isNextPageUrlWarningShown || !isPrevPageUrlWarningShown else { return }
        isNextPageUrlWarningShown = true
        isPrevPageUrlWarningShown = true
        
        if nextPageUrl == nil {
            print("No next page url")
        }
        if prevPageUrl == nil {
            print("No prev page url")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.isNextPageUrlWarningShown = false
            self?.isPrevPageUrlWarningShown = false
        }
    }
    
    func numberOfRows() -> Int {
        if !filteredCharacters.isEmpty {
            return self.filteredCharacters.count
        } else {
            return self.characters.count
        }
    }
    
    func resultCell(at index: Int) -> ResultsCharactersModel {
        if !filteredCharacters.isEmpty {
            return filteredCharacters[index]
        } else {
            return self.characters[index]
        }
    }
    
    func searchCharacters(with query: String) {
        if query.isEmpty || query.count < 3 {
            self.filteredCharacters = []
        } else {
            self.filteredCharacters = self.characters.filter { $0.name.lowercased().contains(query.lowercased()) }
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
