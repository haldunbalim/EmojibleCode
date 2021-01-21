//
//  OpeningCodingScreen.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 22.12.2020.
//

import UIKit

class OpeningCodingScreen: UIViewController, Coordinated, UIViewControllerWithAlerts{
    var pleaseWaitAlert: UIAlertController?
    
    var coordinator: Coordinator?
    
    @IBOutlet weak var codingScreen: UITextView!
    @IBOutlet weak var runButton: UIButton!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        self.navigationController?.navigationBar.isHidden = true
        configureViews()
        configureLanguage()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
        self.imagePicker.presentCamera(from: sender)
    }
    
    @IBAction func photoLibraryPressed(_ sender: UIButton) {
        self.imagePicker.presentImagePicker(from: sender)
        
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        if codingScreen.text != "" {
            AppCoordinator.getInstance().runCode(code: codingScreen.text)
        }
    }
}

extension OpeningCodingScreen: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        showSpinner(){
            VisionModel.getInstance().predictEmojis(image: image){ result in
                self.hideSpinner()
                if let res = result{
                    self.codingScreen.text = res
                }else{
                    return
                }
            
            }
        }
    }
}

