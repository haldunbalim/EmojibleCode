//
//  TutorialVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import UIKit

struct Tutorial {
    let color: UIColor
    let level: String
    let tutorial_number: String
}

let reuseIdentifier = "TutorialViewCell"

class TutorialScreenVC: UICollectionViewController, Coordinated{
    var coordinator: Coordinator?

    var tutorials = [Tutorial]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TutorialViewCell", bundle:nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "TutorialViewCell")
        
        //collectionView.register(UINib(nibName: "TutorialViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let tutorial1 = Tutorial(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), level: "Beginner", tutorial_number: "Tutorial 1")
        let tutorial2 = Tutorial(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), level: "Beginner", tutorial_number: "Tutorial 2")
        let tutorial3 = Tutorial(color: #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), level: "Intermediate", tutorial_number: "Tutorial 3")
        let tutorial4 = Tutorial(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), level: "Advance", tutorial_number: "Tutorial 4")
        
        tutorials = [tutorial1, tutorial2, tutorial3, tutorial4]
    }
 

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorials.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = UICollectionViewCell()
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TutorialViewCell {
            cell.configureView(tutorial: tutorials[indexPath.row])
        }
        return cell
        
    }
}
