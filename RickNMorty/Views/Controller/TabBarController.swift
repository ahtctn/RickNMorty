//
//  TabBarController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 4.08.2023.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Custom tab bar oluşturun
        let customTabBar = CustomTabBar(frame: self.tabBar.frame)
        customTabBar.backgroundColor = UIColor(red: 0.52, green: 0.71, blue: 0.31, alpha: 1.0) // Tab Bar arkaplan rengini ayarlayın
        
        // Tab Bar'ı değiştirin
        self.tabBar.removeFromSuperview()
        self.setValue(customTabBar, forKey: "tabBar")
        
        // Tab Bar'ı oluşturun
        let charactersVC = CharactersViewController()
        let episodesVC = EpisodesViewController()
        let settingsVC = SettingsViewController()
        
        // View Controller'ları Tab Bar'a ekleyin
        let viewControllers = [charactersVC, episodesVC, settingsVC]
        self.setViewControllers(viewControllers, animated: false)
    }
}



class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        
        // Tab Bar'ın boyutunu istediğiniz şekilde ayarlayın
        let tabBarHeight: CGFloat = 80
        sizeThatFits.height = tabBarHeight
        
        return sizeThatFits
    }
}
