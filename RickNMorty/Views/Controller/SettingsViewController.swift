//
//  SettingsViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var githubButton: UIButton!
    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var gmailButton: UIButton!
    
    let selectedImage = UIImage(named: "gear")
    let unselectedImage = UIImage(named: "gearUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarDelegations()
    }
    
    private func tabbarDelegations() {
        tabBarItem = UITabBarItem(title: "", image: unselectedImage, selectedImage: selectedImage)
        self.tabBarController?.navigationItem.title = "Info"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "greenColor")
        let attirbutes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attirbutes
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        //GitHub
        case 0:
            openLink(urlString: Constants.Links.githubLink)
        //Linkedin
        case 1:
            openLink(urlString: Constants.Links.linkedinLink)
        //Twitter
        case 2:
            openLink(urlString: Constants.Links.twitterLink)
        //Gmail
        case 3:
            openLink(urlString: Constants.Links.gmailLink)
        default:
            fatalError("tag error")
        }
    }
    
    private func openLink(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
