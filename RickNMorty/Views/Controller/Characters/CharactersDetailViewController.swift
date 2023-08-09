//
//  CharactersDetailViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 10.08.2023.
//

import UIKit

class CharactersDetailViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderGenericView!
    
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!

    var character: ResultsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        configureUI()
    }
    
    private func setHeaderView() {
        self.headerView.headerText.text = "character detail".capitalized
        self.headerView.addLottieAnimation(animationName: Constants.HeaderAnimations.mortyCrying)
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
    }

}
