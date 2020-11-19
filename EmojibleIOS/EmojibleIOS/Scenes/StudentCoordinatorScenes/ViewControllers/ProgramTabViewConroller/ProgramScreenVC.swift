//
//  CodingScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import UIKit


private let reuseIdentifier = "ProgramScreenCell"

class ProgramScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    var tutorials = TutorialDataSource.getInstance().getTutorials()
    var previousCodes = PreviousCodeDataSource.getInstance().getPreviousCodes()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Programs"
        configureCollectionView()
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProgramViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
    }
}


extension ProgramScreenVC: UICollectionViewDelegate{
}

extension ProgramScreenVC: UICollectionViewDelegateFlowLayout{
}

extension ProgramScreenVC: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return section==0 ? tutorials.count: previousCodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProgramViewModel {
            if indexPath.section == 0{
                cell.configureView(codeModel: tutorials[indexPath.row])
            }else{
                cell.configureView(codeModel: previousCodes[indexPath.row])
            }
            NSLayoutConstraint(item: cell, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 150).isActive = true
            
            return cell
        }
        
        else{
            return UICollectionViewCell()
        }

    }
}
