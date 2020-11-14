//
//  CollectionViewController.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

private let reuseIdentifier = "TutorialScreenCell"

class TutorialScreenVC: UIViewController, Coordinated {
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
        self.title = "Tutorials"
        configureCollectionView()
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CodeViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
    }
}

extension TutorialScreenVC: UICollectionViewDelegate{

}

extension TutorialScreenVC: UICollectionViewDelegateFlowLayout{
}

extension TutorialScreenVC: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return section==0 ? tutorials.count: previousCodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CodeViewModel {
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
