//
//  TabBarController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 4.08.2023.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // Custom tab bar oluşturun
    //        let customTabBar = CustomTabBar(frame: self.tabBar.frame)
    //        customTabBar.backgroundColor = UIColor(red: 0.52, green: 0.71, blue: 0.31, alpha: 1.0) // Tab Bar arkaplan rengini ayarlayın
    //
    //        // Tab Bar'ı değiştirin
    //        self.tabBar.removeFromSuperview()
    //        self.setValue(customTabBar, forKey: "tabBar")
    //
    //        // Tab Bar'ı oluşturun
    //        let charactersVC = CharactersViewController()
    //        let episodesVC = EpisodesViewController()
    //        let settingsVC = SettingsViewController()
    //
    //        // View Controller'ları Tab Bar'a ekleyin
    //        let viewControllers = [charactersVC, episodesVC, settingsVC]
    //        self.setViewControllers(viewControllers, animated: false)
    //    }
    
    var upperLineView: UIView!
    
    let spacing: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.addTabbarIndicatorView(index: 0, isFirstTime: true)
        }
    }
    
    ///Add tabbar item indicator uper line
    func addTabbarIndicatorView(index: Int, isFirstTime: Bool = false){
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        if !isFirstTime{
            upperLineView.removeFromSuperview()
        }
        upperLineView = UIView(frame: CGRect(x: tabView.frame.minX + spacing, y: tabView.frame.minY + 0.1, width: tabView.frame.size.width - spacing * 2, height: 4))
        upperLineView.backgroundColor = UIColor(named: "greenColor")
        tabBar.addSubview(upperLineView)
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

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        addTabbarIndicatorView(index: self.selectedIndex)
    }
}
