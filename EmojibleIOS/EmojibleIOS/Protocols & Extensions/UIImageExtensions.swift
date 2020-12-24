//
//  UIImageExtensions.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 24.12.2020.
//

import Foundation
import UIKit
import Accelerate

extension UIImage{
    func resized(to size: CGSize) -> UIImage {
            return UIGraphicsImageRenderer(size: size).image { _ in
                draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func cropped(rect: CGRect) -> UIImage? {
        guard let cgImage = cgImage else { return nil }

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        context?.translateBy(x: 0.0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(cgImage, in: CGRect(x: rect.minX, y: rect.minY, width: self.size.width, height: self.size.height), byTiling: false)


        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return croppedImage
    }
}
