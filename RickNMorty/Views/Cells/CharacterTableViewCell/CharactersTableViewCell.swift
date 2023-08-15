//
//  CharactersTableViewCell.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit
import Kingfisher

class CharactersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ResultsCharactersModel) {
        headerLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        headerLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        
        DispatchQueue.main.async {
            if let chImage = item.image {
                self.characterImage.setImage(with: chImage)
                self.characterImage.layer.cornerRadius = 10
            } else {
                self.characterImage.image = UIImage(systemName: "person.fill")
            }
        }
        
        self.headerLabel.text = item.name
        self.descriptionLabel.text = item.species
        
        
        switch item.gender {
        case "Male":
            genderImageView.image = UIImage(named: "male")
        case "Female":
            genderImageView.image = UIImage(named: "female")
        case "Genderless":
            genderImageView.image = UIImage(named: "genderless")
        case "unknown":
            genderImageView.image = UIImage(named: "unknown")
        default:
            genderImageView.image = UIImage(named: "person.fill")
        }
        
        switch item.status {
        case "Dead":
            self.statusImageView.image = UIImage(named: "dead")
        case "Alive":
            self.statusImageView.image = UIImage(named: "alive")
        case "unknown":
            self.statusImageView.image = UIImage(named: "unknown")
        default:
            self.statusImageView.image = UIImage(systemName: "person.fill")
        }
        
        self.makeArrow()
        
    }
    
    private func makeArrow() {
        let indicatorColor = UIColor(named: "greenColor")!
        let indicatorSize = CGSize(width: 30, height: 20)
        if let arrowImage = UIImage.rightArrowImage(with: indicatorColor, size: indicatorSize) {
            let indicatorImageView = UIImageView(image: arrowImage)
            indicatorImageView.tintColor = UIColor(named: "greenColor")
            self.accessoryView = indicatorImageView
        }
    }
    
    
    
}

