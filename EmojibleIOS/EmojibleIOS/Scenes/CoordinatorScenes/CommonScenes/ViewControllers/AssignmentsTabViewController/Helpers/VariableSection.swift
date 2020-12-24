//
//  VariableSection.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 25.11.2020.
//

import UIKit

private let reuseIdentifier2 = "VariablesViewModel"

class VariableSection: UICollectionViewCell{
    var variables : [String] = []
    
    var variableDelegate: AssignmentTabVariableSectionAction?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 7.5
        layout.minimumInteritemSpacing = 8
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
        
        collectionView.register(UINib(nibName: "VariablesViewModel", bundle:.main), forCellWithReuseIdentifier: reuseIdentifier2)
    }
    
    func reload(){
        variables = EmojiChecker.getInstance().getAvailableEmojis()
        collectionView.reloadData()
    }
}
//MARK: - VariableCell methods

extension VariableSection: UICollectionViewDelegate{}
extension VariableSection: UICollectionViewDelegateFlowLayout{}

extension VariableSection: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let variableCellSize = CGFloat(30)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as? VariablesViewModel {
        
            cell.configureView(emoji: variables[indexPath.row])
            
            NSLayoutConstraint.activate([cell.heightAnchor.constraint(equalToConstant: variableCellSize),
                                         cell.widthAnchor.constraint(equalToConstant: variableCellSize)])
            
            cell.variableDelegate = self
            
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
}

//MARK: - Button action protocols

extension VariableSection:AssignmentTabVariableSectionAction{
    func variableAction(emoji: String) {
        self.variableDelegate?.variableAction(emoji: emoji)
    }
}
