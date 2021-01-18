//
//  OpeningCodingScreen.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 22.12.2020.
//

import UIKit

class OpeningCodingScreen: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    @IBOutlet weak var codingScreen: UITextView!
    @IBOutlet weak var runButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = true
        configureViews()
        configureLanguage()
    }
    func configureLanguage(){
        codingScreen.text = "Write your code...".localized()
        runButton.setTitle("Run".localized().uppercased(), for: .normal)
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([
            codingScreen.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        NSLayoutConstraint.activate([
            runButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
    }
    
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraView = UIImagePickerController()
            cameraView.delegate = self as?
                UIImagePickerControllerDelegate & UINavigationControllerDelegate
            cameraView.sourceType = .camera
            self.present(cameraView, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoLibraryPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        if codingScreen.text != "" {
            CommonCoordinator.getInstance().runCode(code: codingScreen.text)
        }
    }
}
