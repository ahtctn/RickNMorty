//
//  EpisodesDetailViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 7.08.2023.
//

import UIKit

class EpisodesDetailViewController: UIViewController {
    
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var episodeDetailVM = EpisodesDetailViewModel()
    private var episodeVM = EpisodesViewModel()
    
    
    var episodes: ResultEpisodesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeEvent()
        delegations()
        
    }
    
    private func delegations() {
        DispatchQueue.main.async {
            self.collectionView.register(UINib(nibName: "EpisodeCharactersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellIDCharacters)
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
        }
        
    }
    
    private func setupUI() {
        if let episode = episodes {
            episodeLabel.text = episode.name
            nameLabel.text = episode.episode
            airDateLabel.text = episode.airDate
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func observeEvent() {
        
        guard let episode = episodes else { return }
        
        episodeDetailVM.getCharactersInEpisode(with: episode.characters)
        
        episodeDetailVM.eventHandler = { event in
            
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

extension EpisodesDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodeDetailVM.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.episodeDetailVM.resultCell(at: indexPath.row)
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellIDCharacters, for: indexPath) as? EpisodeCharactersCollectionViewCell else {
            return UICollectionViewCell()
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
        
        let selectedCharacter = episodeDetailVM.resultCell(at: indexPath.row)
        if let charactersDetailVC = storyboard?.instantiateViewController(withIdentifier: Constants.goToCharacterDetailFromEpisodesID) as? CharactersDetailViewController {
            charactersDetailVC.character = selectedCharacter
            navigationController?.pushViewController(charactersDetailVC, animated: true)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
