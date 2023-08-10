//
//  CharacterEpisodesCollectionViewCell.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 10.08.2023.
//

import UIKit

class CharacterEpisodesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setUI() {
        self.layer.cornerRadius = 20
    }
    
    func configure(with item: ResultEpisodesModel) {
        self.episodeNameLabel.text = item.name
        self.episodeNumberLabel.text = item.episode
        
        setUI()
    }

}
