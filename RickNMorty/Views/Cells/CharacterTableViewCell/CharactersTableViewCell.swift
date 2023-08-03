//
//  CharactersTableViewCell.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class CharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ResultsModel) {
        headerLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        headerLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        self.characterImage.image = UIImage(systemName: "person.fill") ?? UIImage(systemName: "person")
        self.headerLabel.text = item.name
        self.descriptionLabel.text = item.gender
    }
    
}
