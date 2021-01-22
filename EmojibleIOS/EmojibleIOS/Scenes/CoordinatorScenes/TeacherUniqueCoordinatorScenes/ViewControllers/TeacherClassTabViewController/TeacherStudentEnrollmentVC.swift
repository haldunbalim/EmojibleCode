//
//  TeacherStudentEnrollmentVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 16.12.2020.
//

import Foundation
import UIKit

private let reuseIdentifier = "StudentCell"

class TeacherStudentEnrollmentVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var classroom: ClassModel?
    var students: [StudentModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.classroom = (self.coordinator as! TeacherClassCoordinator).classroom
        configureView()
        configureLanguage()
        configureTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .studentsInClassChanged, object: nil)
        StudentsInClassDataSource.getInstance().startObservingStudentsInAClass(classId: classroom!.id)
    }
    
    func configureLanguage(){
        backButton.setTitle("BACK".localized(), for: .normal)
    }
    
    @objc func notify(_ notification: NSNotification){
        guard let studentsFromDB = notification.userInfo?["studentsInClassChanged"] else { return }
        students = studentsFromDB as! [StudentModel]
        tableView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        (self.coordinator as! TeacherClassCoordinator).pop()
    }
    
    func configureView(){
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH)])
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ClassStudentInfoViewModel", bundle: .main), forCellReuseIdentifier: reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = .white
        tableView.backgroundColor = .white

        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 20)])
    }
}


extension TeacherStudentEnrollmentVC:UITableViewDelegate{}
extension TeacherStudentEnrollmentVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.students.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ClassStudentInfoViewModel{
            if indexPath.row == 0{
                cell.configureNameCell(name: self.classroom?.className ?? "", id: self.classroom?.id ?? "" )
            }else if indexPath.row == 1{
                cell.configureSumCell(sum: self.students.count)
            }
            else{
                let student = self.students[indexPath.row-2]
                cell.configureStudentCell(name: student.name, surname: student.surname)
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
