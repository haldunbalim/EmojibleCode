//
//  ViewControllerExtensions.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit

extension UIViewController{
    func showMessagePrompt(_ message: String?, vcToBePresented:UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        vcToBePresented.present(alert, animated: true)
    }
}

