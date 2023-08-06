//
//  SettingsViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var headerView: HeaderGenericView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.headerText.text = "settings".capitalized
        headerView.headerImage.setImage(with: Constants.headerImageUrl)
    }
    
    
}
