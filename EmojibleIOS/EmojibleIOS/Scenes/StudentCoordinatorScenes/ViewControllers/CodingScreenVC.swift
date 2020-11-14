//
//  CodingScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import UIKit

class CodingScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        configureNavigationBar()
    }
    
    private func configureNavigationBar(){
        let cameraItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonPressed))
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.addTarget(self, action: #selector(photosButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let photosItem = UIBarButtonItem(customView: button)
        
        navigationItem.rightBarButtonItems = [cameraItem,photosItem]
    }
    
    @objc func cameraButtonPressed() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraView = UIImagePickerController()
            cameraView.delegate = self as?
                UIImagePickerControllerDelegate & UINavigationControllerDelegate
            cameraView.sourceType = .camera
            self.present(cameraView, animated: true, completion: nil)
        }
    }
    
    @objc func photosButtonPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
}
