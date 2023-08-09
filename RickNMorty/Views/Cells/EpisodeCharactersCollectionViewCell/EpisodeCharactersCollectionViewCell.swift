//
//  EpisodeCharactersCollectionViewCell.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 9.08.2023.
//

import UIKit

class EpisodeCharactersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setUI() {
        self.layer.cornerRadius = 20
        characterImage.layer.cornerRadius = 20
    }
    
    
    func configure(with item: ResultsModel) {
        self.characterImage.setImage(with: item.image ?? Constants.headerImageUrl)
        self.characterName.text = item.name
        setUI()
    }
    
}
