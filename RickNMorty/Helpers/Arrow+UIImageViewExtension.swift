//
//  Arrow+UIImageViewExtension.swift
//  RickNMorty
//
//  Created by Ahmet Ali ÇETİN on 4.08.2023.
//
import UIKit

extension UIImage {
    static func rightArrowImage(with color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: size.width * 0.8, y: size.height * 0.5))
        arrowPath.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.2))
        arrowPath.addLine(to: CGPoint(x: size.width * 0.2, y: size.height * 0.8))
        arrowPath.close()

        context.setFillColor(color.cgColor)
        arrowPath.fill()

        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image.withRenderingMode(.alwaysTemplate)
        }

        return nil
    }
}
