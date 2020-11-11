//
//  CollectionViewController.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

private let reuseIdentifier = "TutorialScreenCell"

class TutorialScreenVC: UICollectionViewController, Coordinated {
    var coordinator: Coordinator?
    var tutorials = TutorialDataSource().getTutorialInfo()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(TutorialScreenCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tutorials.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TutorialScreenCell {
            cell.configure(tutorial: tutorials[indexPath.row])
            return cell
        }
        else{
            return UICollectionViewCell()
        }

    }
}
