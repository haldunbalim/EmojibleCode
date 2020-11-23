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
        collectionView.register(UINib(nibName: "TutorialViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 90),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}

extension TutorialScreenVC: UICollectionViewDelegate{
}

extension TutorialScreenVC: UICollectionViewDelegateFlowLayout{
}

extension TutorialScreenVC: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return tutorials.count % 2 == 0 ? tutorials.count/2: Int(tutorials.count/2) + 1
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
        if tutorials.count % 2 == 0 {
            return 2
        }
        else {
            let numberOfSections = Int(tutorials.count/2) + 1
            return section == numberOfSections - 1 ? 1 : 2
        }
         */
        return tutorials.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellHeight = (self.collectionView.frame.height - 40) / CGFloat(2)
        let cellWidht = (self.collectionView.frame.width - 40) / CGFloat(2)
 
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TutorialViewModel {
        
            cell.configureView(codeModel: tutorials[indexPath.section * 2 + indexPath.row])
           
            NSLayoutConstraint.activate([
                cell.heightAnchor.constraint(equalToConstant: cellHeight),
                cell.widthAnchor.constraint(equalToConstant: cellWidht),
            ])
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
 
}
