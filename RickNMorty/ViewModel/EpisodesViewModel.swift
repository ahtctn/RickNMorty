//
//  EpisodesViewModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 7.08.2023.
//

import Foundation

class EpisodesViewModel {
    var episodes: [ResultEpisodesModel] = []
    var eventHandler: ((_ event: Event) -> Void)?
    
    private var nextPageUrl: String?
    private var prevPageUrl: String?
    
    private var isNextPageUrlWarningShown: Bool = false
    private var isPrevPageUrlWarningShown: Bool = false
    
    func getEpisodes() {
        self.eventHandler?(.loading)
        NetworkManager.shared.getEpisodes { result in
            switch result {
            case .success(let episodes):
                self.episodes = episodes.results
                self.nextPageUrl = episodes.info.next
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print("\(error.localizedDescription) get episodes error in episodesViewModel class.")
            }
        }
    }
    
    func getNextPage() {
        guard let nextPageUrl = self.nextPageUrl else {
            showPrevNextPageUrlWarning()
            return
        }
        
        self.eventHandler?(.loading)
        NetworkManager.shared.getOtherPagesEpisodes(url: nextPageUrl) { [weak self] result in
            switch result {
            case .success(let episodes):
                self?.episodes.append(contentsOf: episodes.results)
                self?.nextPageUrl = episodes.info.next
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
        NetworkManager.shared.getOtherPagesEpisodes(url: prevPageUrl) { [weak self] result in
            switch result {
            case .success(let episodes):
                self?.episodes.append(contentsOf: episodes.results)
                self?.nextPageUrl = episodes.info.next
                self?.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error.localizedDescription)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isNextPageUrlWarningShown = false
            self.isPrevPageUrlWarningShown = false
        }
    }
    
    func numberOfRows() -> Int {
        return self.episodes.count
    }
    
    func resultCell(at index: Int) -> ResultEpisodesModel {
        return self.episodes[index]
    }
}

extension EpisodesViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ error: Error?)
    }
}
