//
//  HeaderGenericView.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 6.08.2023.
//

import UIKit

class HeaderGenericView: UIView {

    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    let nibName: String = "HeaderGenericView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    

}
