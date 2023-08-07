//
//  SettingsViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var headerView: HeaderGenericView!
    let selectedImage = UIImage(named: "gear")
    let unselectedImage = UIImage(named: "gearUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.headerText.text = "about me".capitalized
        headerView.addLottieAnimation(animationName: Constants.HeaderAnimations.rickNMortyHeaderAnimation)
        tabBarItem = UITabBarItem(title: "", image: unselectedImage, selectedImage: selectedImage)
    }
    
    
}
