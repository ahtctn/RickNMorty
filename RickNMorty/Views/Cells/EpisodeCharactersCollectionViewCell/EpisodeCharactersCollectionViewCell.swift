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
        characterImage.layer.cornerRadius = characterImage.frame.size.width / 2
        characterImage.clipsToBounds = true
        characterImage.contentMode = .scaleAspectFill
        
        characterImage.layer.shadowColor = UIColor.black.cgColor
        characterImage.layer.shadowOpacity = 0.5
        characterImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        characterImage.layer.shadowRadius = 4
        
    }
    
    
    func configure(with item: ResultsModel) {
        self.characterImage.setImage(with: item.image ?? Constants.headerImageUrl)
        
        self.characterName.text = item.name
        setUI()
    }
    
}
