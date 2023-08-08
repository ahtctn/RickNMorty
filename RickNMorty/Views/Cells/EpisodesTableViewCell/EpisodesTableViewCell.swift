//
//  EpisodesTableViewCell.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 7.08.2023.
//

import UIKit

class EpisodesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with item: ResultEpisodesModel) {
        self.headerLabel.text = item.episode
        self.descriptionLabel.text = item.name
        self.lowerLabel.text = item.airDate
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
