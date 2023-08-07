//
//  EpisodesViewController.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 2.08.2023.
//

import UIKit

class EpisodesViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderGenericView!
    let selectedImage = UIImage(named: "tv")
    let unselectedImage = UIImage(named: "tvUnselected")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTabbarImage()
        setHeaderView()
    }
    
    private func setTabbarImage() {
        tabBarItem = UITabBarItem(title: "", image: unselectedImage, selectedImage: selectedImage)
    }
    
    private func setHeaderView() {
        headerView.addLottieAnimation(animationName: Constants.HeaderAnimations.mortyTwerking)
        headerView.headerText.text = "episodes".capitalized
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
