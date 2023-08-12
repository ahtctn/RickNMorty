//
//  NoResultView.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 12.08.2023.
//

import UIKit
import Lottie

class NoResultView: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var foregroundView: UIView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    static let nibName: String = "NoResultView"
    
    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: NoResultView.nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addAnimation(animationName: String, noResultFor: String?) {
        AnimationHelper.addLottieAnimation(animationName: animationName, viewToAnimate: backgroundView)
        noResultLabel.text = noResultFor
    }

}
