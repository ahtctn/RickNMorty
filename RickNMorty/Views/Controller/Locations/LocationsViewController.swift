//
//  LocationsViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 15.08.2023.
//

import UIKit

class LocationsViewController: UIViewController {

    private let selectedImage = UIImage(named: "earth")
    private let unSelectedImage = UIImage(named: "earthUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarDelegations()
       
    }
    
    private func tabbarDelegations() {
        tabBarItem = UITabBarItem(title: "", image: unSelectedImage, selectedImage: selectedImage)
        self.tabBarController?.navigationItem.title = "Location"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "greenColor")
        let attirbutes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attirbutes
    }
    

    

}
