//
//  CodingScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 19.11.2020.
//

import UIKit

class CodingScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var codingScreen: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        configureViews()
    }
    
    func configureViews(){
        NSLayoutConstraint.activate([
            codingScreen.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        NSLayoutConstraint.activate([
            runButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH)])
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
        if titleField.text != "" && codingScreen.text != "" {
            ProgramDataSource.getInstance().writeProgram(program: CodeModel(name: titleField.text!, code: codingScreen.text))
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        titleField.placeholder = "Enter title..."
        codingScreen.text = "Write your code..."
        (self.coordinator as! ProgramsCoordinator).pop()
    }
}
