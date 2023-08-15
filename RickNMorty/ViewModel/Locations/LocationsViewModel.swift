//
//  LocationsViewModel.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import Foundation

class LocationViewModel {
    var locations: [ResultLocationModel] = []
    var filteredLocations: [ResultLocationModel] = []
    
    var eventHandler: ((_ event: Event) -> Void)?
    
    private var nextPageUrl: String?
    private var prevPageUrl: String?
    
    private var isNextPageUrlWarningShown: Bool = false
    private var isPrevPageUrlWarningShown: Bool = false
    
    func getLocation() {
        self.eventHandler?(.loading)
        NetworkManager.shared.getLocations { result in
            switch result {
            case .success(let locations):
                self.locations = locations.results
                self.nextPageUrl = locations.info.next
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print("\(error.localizedDescription) get locations error in locationsviewmodel class.")
            }
        }
    }
    
    func getNextPage() {
        guard let nextPageUrl = self.nextPageUrl else {
            showPrevNextPageUrlWarning()
            return
        }
        
        self.eventHandler?(.loading)
        NetworkManager.shared.getOtherPagesLocations(url: nextPageUrl) { [weak self] result in
            switch result {
            case .success(let locations):
                self?.locations.append(contentsOf: locations.results)
                self?.nextPageUrl = locations.info.next
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
        NetworkManager.shared.getOtherPagesLocations(url: prevPageUrl) { [weak self] result in
            switch result {
            case .success(let locations):
                self?.locations.append(contentsOf: locations.results)
                self?.nextPageUrl = locations.info.prev
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
        return self.locations.count
    }
    
    func resultCell(at index: Int) -> ResultLocationModel {
        return self.locations[index]
    }
    
    func searchLocations(with query: String) {
        if query.isEmpty || query.count < 3 {
            self.filteredLocations = []
        } else {
            self.filteredLocations = self.locations.filter {
                $0.name.lowercased().contains(query.lowercased())
            }
        }
    }
}

extension LocationViewModel {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(_ error: Error?)
    }
}
