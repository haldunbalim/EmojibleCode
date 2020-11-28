//
//  AssignmentScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

private let headerIdentifier1 = "Assignments"
private let headerIdentifier2 = "Available Emojis"

private let assignmentIdentifier = "Assignment View"
private let variableIdentifier = "Variable View"

class AssignmentScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    
    var assignmentToBeRemoved: AssignmentModel?
    var assignmentToBeEdited: AssignmentModel?
    var newAssignmentIdentifier: String?

    var addVoiceAlert: AddVoiceAlert!
    var addTextAlert: AddTextAlert!
    var addFunctionAlert: AddFunctionAlert!
    var removeAlert: RemoveAlert!
    var editAlert: EditAlert!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Emoji Assignments"
        configureNavigationBar()
        configureCollectionView()
        configureAddVoiceAlert()
        configureAddTextAlert()
        configureAddFunctionAlert()
        configureRemoveAlert()
        configureEditAlert()
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .assignmentsChanged, object: nil)
    }
    
    @objc func notify(){
        collectionView.reloadData()
    }
    
    func configureNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier1)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier2)
        
        collectionView.register(AssignmentSection.self, forCellWithReuseIdentifier: assignmentIdentifier)
        collectionView.register(VariableSection.self, forCellWithReuseIdentifier: variableIdentifier)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
}

//MARK: - Alert methods
extension AssignmentScreenVC {
    func configureAddVoiceAlert(){
        addVoiceAlert = AddVoiceAlert()
        addVoiceAlert.delegate = self
        addVoiceAlert.newVoiceAssignmentDelegate = self
    }
    
    func configureAddTextAlert(){
        addTextAlert = AddTextAlert()
        addTextAlert.delegate = self
        addTextAlert.newTextAssignmentDelegate = self
    }
    
    func configureAddFunctionAlert(){
        addFunctionAlert = AddFunctionAlert()
        addFunctionAlert.delegate = self
        addFunctionAlert.newFunctiontAssignmentDelegate = self
    }
    
    func configureRemoveAlert(){
        removeAlert = RemoveAlert()
        removeAlert.delegate = self
        removeAlert.removeAssignmentDelegate = self
    }
    
    func configureEditAlert(){
        editAlert = EditAlert()
        editAlert.delegate = self
        editAlert.editAssignmentDelegate = self
    }
    
    func addButtonPressed(variable: String){
        self.newAssignmentIdentifier = variable
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
    
    func trashButtonPressed(assignment: AssignmentModel){
        self.assignmentToBeRemoved = assignment
        self.removeAlert.presentOver(viewController: self)
    }
    
    func editButtonPressed(assignment: AssignmentModel){
        self.assignmentToBeEdited = assignment
        self.editAlert.presentOver(viewController: self)
    }
}

//MARK: - CollectionView methods

extension AssignmentScreenVC: UICollectionViewDelegate{}
extension AssignmentScreenVC: UICollectionViewDelegateFlowLayout{}

extension AssignmentScreenVC: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: collectionView.frame.size.width, height: 20)
        }else {
            return CGSize(width: collectionView.frame.size.width, height: 20)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if indexPath.section == 0{
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier1, for: indexPath) as! SectionHeader

            headerView.setLabel(text: "Assignments")
            return headerView
        }
        else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier2, for: indexPath) as! SectionHeader
            
            headerView.setLabel(text: "Available Emojis")
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellHeight = (self.collectionView.frame.height-80) / CGFloat(2)
        let cellWidht = self.collectionView.frame.width
        
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: assignmentIdentifier, for: indexPath) as? AssignmentSection {
               
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht)])
                
                cell.editDelegate = self
                cell.trashDelegate = self
                
                cell.reload()
                return cell
            }
        }else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: variableIdentifier, for: indexPath) as? VariableSection {
               
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht)])
                
                cell.variableDelegate = self
                
                cell.reload()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

//MARK: - Button Action Protocols

extension AssignmentScreenVC: AssignmentTabVariableSectionAction {
    func variableAction(emoji: String) {
        self.addButtonPressed(variable: emoji)
    }
}

extension AssignmentScreenVC: AssignmentTabAssignmentSectionAction{
    func editAction(assignment: AssignmentModel) {
        self.editButtonPressed(assignment: assignment)
    }
    
    func trashAction(assignment: AssignmentModel) {
        self.trashButtonPressed(assignment: assignment)
    }
}

//MARK: - Alert protocols
extension AssignmentScreenVC: AssignmentRemovalAlert{}
extension AssignmentScreenVC: AssignmentEditAlert {}
extension AssignmentScreenVC: AssignmentNewAssignmentAlert{}
