//
//  TeacherClassVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 15.12.2020.
//

import Foundation
import UIKit

private let reuseIdentifier = "ClassScreenCell"

class TeacherClassVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    var classDetails: [ClassModel] = []
    
    var removeAlert: RemoveAlert!
    var newClassAlert: CreateNewClassAlert!
    var wrongInput: DisplayWarningAlert!
    
    var classToBeRemoved: ClassModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        configureTableView()
        configureWrongInputAlert()
        configureRemoveAlert()
        configureNewClassAlert()
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .teacherClassChanged, object: nil)
        TeacherClassDataSource.getInstance().startObservingClass()
    }
    
    @objc func notify(_ notification: NSNotification){
        guard let classes = notification.userInfo?["teacherClassChanged"] else { return }
        classDetails = classes as! [ClassModel]
        tableView.reloadData()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TeacherClassViewModel", bundle: .main), forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = UIColor.white

        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 20)])
    }
    
    func configureRemoveAlert(){
        removeAlert = RemoveAlert()
        removeAlert.delegate = self
        removeAlert.removeTeacherClassDelegate = self
    }
    
    func configureNewClassAlert(){
        newClassAlert = CreateNewClassAlert()
        newClassAlert.delegate = self
        newClassAlert.warningDelegate = self
    }
    
    func configureWrongInputAlert(){
        wrongInput = DisplayWarningAlert()
        wrongInput.delegate = self
    }
}

extension TeacherClassVC:UITableViewDelegate{}

extension TeacherClassVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDetails.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TeacherClassViewModel{
        
            if indexPath.row == 0{
                cell.newClassDelegate = self
                cell.configureCreateButton()
            }
            
            else{
                cell.openClassDelegate = self
                cell.trashDelegate = self
                cell.configureClassCell(classroom: classDetails[indexPath.row - 1])
            }
            
            return cell
        
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
 

extension TeacherClassVC:TeacherClassTabButtonAction{
    func trashAction(classroom: ClassModel) {
        self.classToBeRemoved = classroom
        removeAlert.presentOver(viewController: self)
    }
    
    func newClassAction() {
        newClassAlert.presentOver(viewController: self)
    }
    
    func openClassAction(classroom:ClassModel) {
        (self.coordinator as! TeacherClassCoordinator).classroom = classroom
        (self.coordinator as! TeacherClassCoordinator).openScreen(screenName: .StudentInfo)
    }
}

extension TeacherClassVC: WarningAlert{
    func warningAction(warning: String) {
        self.wrongInput.presentOver(viewController: self)
        self.wrongInput.configureWarning(text: warning)
    }
}

extension TeacherClassVC: TeacherClassRemovalAlert{}

