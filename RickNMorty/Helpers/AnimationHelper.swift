//
//  Animation.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 12.08.2023.
//

import UIKit
import Lottie
class AnimationHelper {
    static func addLottieAnimation(animationName: String, viewToAnimate: UIView?) {
        let animationView = LottieAnimationView(name: animationName)
        animationView.frame = viewToAnimate!.bounds
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        viewToAnimate!.addSubview(animationView)
        
        animationView.play()
    }
}
