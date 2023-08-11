//
//  CharactersDetailViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 10.08.2023.
//

import UIKit

class CharactersDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    private var characterDetailVM = CharactersDetailViewModel()
    private var charactersVM = CharactersViewModel()
    
    
    var character: ResultsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        delegations()
        observeEvent()
    }
    
    private func delegations() {
        DispatchQueue.main.async {
            self.collectionView.register(UINib(nibName: "CharacterEpisodesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellIDEpisodes)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    private func configureUI() {
        if let character = character {
            characterImage.setImage(with: character.image ?? Constants.headerImageUrl)
            nameLabel.text = character.name
            statusLabel.text = character.status
            speciesLabel.text = character.species
            if character.type != "" {
                typeLabel.text = character.type
            } else {
                typeLabel.isHidden = true
                typeNameLabel.isHidden = true
            }
            genderLabel.text = character.gender
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
        // Daire maskesi oluşturarak UIImageView içeriğini daire şeklinde keseceğiz
        let maskLayer = CAShapeLayer()
        let circularPath = UIBezierPath(roundedRect: characterImage.bounds, cornerRadius: characterImage.bounds.width / 2)
        maskLayer.path = circularPath.cgPath
        characterImage.layer.mask = maskLayer
        
        characterImage.layer.shadowColor = UIColor.black.cgColor
        characterImage.layer.shadowOpacity = 0.5
        characterImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        characterImage.layer.shadowRadius = 4
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func observeEvent() {
        guard let character = character else { return }
        
        characterDetailVM.getEpisodesInCharacter(with: character.episode)
        
        characterDetailVM.eventHandler = { event in
            switch event {
            case .loading:
                print("data is loading")
            case .stopLoading:
                print("data stopped loading")
            case .dataLoaded:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .error(let error):
                print(error!.localizedDescription as Any)
                
            }
        }
    }
}

extension CharactersDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterDetailVM.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.characterDetailVM.resultCell(at: indexPath.row)
        
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellIDEpisodes, for: indexPath) as? CharacterEpisodesCollectionViewCell else {
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
        let selectedEpisode = characterDetailVM.resultCell(at: indexPath.row)
        if let episodeDetailVC = storyboard?.instantiateViewController(withIdentifier: Constants.goToEpisodeDetailFromCharacterID) as? EpisodesDetailViewController {
            episodeDetailVC.episodes = selectedEpisode
            navigationController?.pushViewController(episodeDetailVC, animated: true)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}
