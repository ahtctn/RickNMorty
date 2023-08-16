//
//  LocationsDetailViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import UIKit

class LocationsDetailViewController: UIViewController {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locations: ResultLocationModel?
    private var locationVM = LocationViewModel()
    private var locationDetailVM = LocationsDetailViewModel()
    
    var character: ResultsCharactersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegations()
        setupUI()
        observeEvent()
    }
    
    private func delegations() {
        DispatchQueue.main.async {
            self.collectionView.register(UINib(nibName: "EpisodeCharactersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellIDCharacters)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        }
    }
    
    private func setupUI() {
        if let location = locations {
            locationNameLabel.text = location.name
            typeLabel.text = location.type
            dimensionLabel.text = location.dimension
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func observeEvent() {
        guard let location = locations else { return }
        locationDetailVM.getCharactersInLocation(with: location.residents)
        locationDetailVM.eventHandler = { event in
            switch event {
            case .loading:
                print("data is loading")
            case .stopLoading:
                print("data stopped loading")
            case .dataLoaded:
                print("data loaded")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .error(let error):
                print(error?.localizedDescription as Any)
            }
            
        }
    }
}

extension LocationsDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationDetailVM.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.locationDetailVM.resultCell(at: indexPath.row)
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellIDCharacters, for: indexPath) as? EpisodeCharactersCollectionViewCell else { return UICollectionViewCell()
        }
        
        item.configure(with: cell)
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = 128
        return CGSize(width: widthPerItem, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCharacter = locationDetailVM.resultCell(at: indexPath.row)
        if let locationDetailVC = storyboard?.instantiateViewController(withIdentifier: Constants.goToCharacterDetailFromEpisodesID) as? CharactersDetailViewController {
            locationDetailVC.character = selectedCharacter
            navigationController?.pushViewController(locationDetailVC, animated: true)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}
