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

    @IBOutlet weak var codingTextBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraView = UIImagePickerController()
            cameraView.delegate = self as?
                UIImagePickerControllerDelegate & UINavigationControllerDelegate
            cameraView.sourceType = .camera
            self.present(cameraView, animated: true, completion: nil)
        }
    }
    
    @IBAction func photosButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func runButtonPressed(_ sender: UIButton) {
    
    }
}
