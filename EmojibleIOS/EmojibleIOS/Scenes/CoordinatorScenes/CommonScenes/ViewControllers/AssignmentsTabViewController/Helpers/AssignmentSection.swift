//
//  AssignmentSection.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 25.11.2020.
//

import UIKit

private let reusableIdentifier = "AssignmentViewModel"

class AssignmentSection: UICollectionViewCell{
    
    var assignments: [AssignmentModel] = []
    var editDelegate: AssignmentTabAssignmentSectionAction?
    var trashDelegate: AssignmentTabAssignmentSectionAction?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero , collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView(){
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: self.topAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "AssignmentViewModel", bundle: .main), forCellWithReuseIdentifier: reusableIdentifier)
    }
    
    func reload(assignments: [AssignmentModel]){
        self.assignments = assignments
        collectionView.reloadData()
    }
}
//MARK: - AssignmentCell methods
extension AssignmentSection: UICollectionViewDelegate{}
extension AssignmentSection: UICollectionViewDelegateFlowLayout{}
extension AssignmentSection: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellHeight = self.collectionView.frame.height / CGFloat(4)
        let cellWidth = (self.collectionView.frame.width - 40) / CGFloat(2)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as? AssignmentViewModel {
        
            cell.configureView(assignment: assignments[indexPath.row])
            
            NSLayoutConstraint.activate([
                cell.heightAnchor.constraint(equalToConstant: cellHeight),
                cell.widthAnchor.constraint(equalToConstant: cellWidth)])
            
            cell.editDelegate = self
            cell.trashDelegate = self
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
}
//MARK: - Button action protocols

extension AssignmentSection:AssignmentTabAssignmentSectionAction{
    func editAction(assignment: AssignmentModel) {
        editDelegate?.editAction(assignment: assignment)
    }
    
    func trashAction(assignment: AssignmentModel) {
        trashDelegate?.trashAction(assignment: assignment)
    }
}
