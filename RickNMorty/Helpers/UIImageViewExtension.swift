//
//  UIImageViewExtension.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 3.08.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String ) {
        guard let url = URL.init(string: urlString) else {
            print("kingfisher url error")
            return
        }
        
        let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        kf.setImage(with: resource)
    }
}
