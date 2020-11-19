//
//  AssignmentScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit
import SwipeCellKit

fileprivate let reuseIdentifier = "AssignmentViewModel"
class AssignmentScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    var assignments = GlobalMemory.getInstance().getAssignments()
    
    var addVoiceAlert: AddVoiceAlert!
    var addTextAlert: AddTextAlert!
    var addFunctionAlert: AddFunctionAlert!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
        configureAddVoiceAlert()
        configureAddTextAlert()
        configureAddFunctionAlert()
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .assignmentsChanged, object: nil)
    }
    
    @objc func notify(){
        assignments = GlobalMemory.getInstance().getAssignments()
        tableView.reloadData()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "AssignmentViewModel", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    func configureNavigationBar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    
    func configureAddVoiceAlert(){
        addVoiceAlert = AddVoiceAlert()
        addVoiceAlert.delegate = self
    }
    
    func configureAddTextAlert(){
        addTextAlert = AddTextAlert()
        addTextAlert.delegate = self
    }
    
    func configureAddFunctionAlert(){
        addFunctionAlert = AddFunctionAlert()
        addFunctionAlert.delegate = self
    }
    
    @objc func addButtonPressed(){
        let alert = UIAlertController(title: nil, message: "Select Type", preferredStyle: .alert)
        let addTextAction = UIAlertAction(title: "Add Text", style: .default){_ in 
            self.addTextAlert.presentOver(viewController:self)
        }
        let addVoiceAction = UIAlertAction(title: "Add Voice", style:.default){_ in 
            self.addVoiceAlert.presentOver(viewController:self)
        }
        let addFunctionAction = UIAlertAction(title: "Add Function", style: .default) {_ in
            self.addFunctionAlert.presentOver(viewController:self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(addTextAction)
        alert.addAction(addVoiceAction)
        alert.addAction(addFunctionAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

extension AssignmentScreenVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            GlobalMemory.getInstance().removeContent(assignment: self.assignments[indexPath.row])
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed

        return [deleteAction]
    }
}



extension AssignmentScreenVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AssignmentScreenVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AssignmentViewModel
    
        cell.delegate = self
        cell.configureView(assignment: assignments[indexPath.row])
        
        return cell
    }
}

