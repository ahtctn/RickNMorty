//
//  LocationTableViewCell.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with item: ResultLocationModel) {
        self.nameLabel.text = item.name
        self.typeLabel.text = item.type.lowercased()
        self.dimensionLabel.text = item.dimension.lowercased()
        
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
