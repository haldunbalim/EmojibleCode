//
//  PleaseWaitProtocol.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit

protocol UIViewControllerWithAlerts: UIViewController{
    var pleaseWaitAlert: UIAlertController? {get set}
    
}

extension UIViewControllerWithAlerts{
    
    func showSpinner(_ completion: (() -> Void)? = nil) {
        if pleaseWaitAlert != nil {
            if completion != nil {
                completion?()
            }
            return
        }
        
        pleaseWaitAlert = UIAlertController(title: nil, message: "Please Wait".localized() + "...\n\n\n\n", preferredStyle: .alert)
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.black
        spinner.center = CGPoint(x: pleaseWaitAlert!.view.bounds.size.width / 2, y: pleaseWaitAlert!.view.bounds.size.height / 2)
        spinner.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        spinner.startAnimating()
        pleaseWaitAlert!.view.addSubview(spinner)
        
      
        present(pleaseWaitAlert!, animated: true, completion: completion)
    }
    
    
    func hideSpinner(_ completion: (() -> Void)? = nil) {
        
        pleaseWaitAlert!.dismiss(animated: true, completion: completion)
        pleaseWaitAlert = nil
        
    }

}
