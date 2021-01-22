//
//  TeacherCodingScreen.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 12.12.2020.
//

import UIKit

class TeacherCodingScreenVC: UIViewController, Coordinated, UIViewControllerWithAlerts{
    var pleaseWaitAlert: UIAlertController?
    
    var coordinator: Coordinator?
 
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var codingScreen: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var runButton: UIButton!
    var imagePicker: ImagePicker!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        configureViews()
        configureLanguage()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

    }
    
    func configureLanguage(){
        backButton.setTitle("TUTORIALS".localized(), for: .normal)
        runButton.setTitle("Run & Share".localized().uppercased(), for: .normal)
        titleField.placeholder = "Enter title...".localized()
        codingScreen.text = "Write your code...".localized()
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
        self.imagePicker.presentCamera(from: sender)

    }
    
    @IBAction func photoLibraryPressed(_ sender: UIButton) {
        self.imagePicker.presentImagePicker(from: sender)
    }
    
    @IBAction func runPressed(_ sender: UIButton) {
        if titleField.text != "" && codingScreen.text != "" {
            TeacherTutorialDataSource.getInstance().writeTutorial(tutorial: CodeModel(name: titleField.text!, code: codingScreen.text))
        }
        AppCoordinator.getInstance().runCode(code: codingScreen.text)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        titleField.placeholder = "Enter title...".localized()
        codingScreen.text = "Write your code...".localized()
        (self.coordinator as! TeacherTutorialCoordinator).pop()
    }
}

extension TeacherCodingScreenVC: ImagePickerDelegate {

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




