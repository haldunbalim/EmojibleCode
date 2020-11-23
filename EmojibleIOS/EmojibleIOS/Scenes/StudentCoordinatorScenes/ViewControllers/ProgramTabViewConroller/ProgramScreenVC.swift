//
//  CodingScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

import Foundation
import UIKit


private let reuseIdentifier = "ProgramScreenCell"
private let reuseIdentifier2 = "ProgramAddCell"


class ProgramScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
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
        //configureNavigationBar()
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ProgramViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(UINib(nibName: "ProgramNewCodeViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier2)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 90),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    func configureNavigationBar(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newCodeButtonPressed))
    }
    
    @objc func newCodeButtonPressed(){
        (self.coordinator as! ProgramsCoordinator).openScreen(screenName: .CodingScreen)
    }
}


extension ProgramScreenVC: UICollectionViewDelegate{
    
}

extension ProgramScreenVC: UICollectionViewDelegateFlowLayout{
    
}

extension ProgramScreenVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /*
        let totalNumberOfCells = previousCodes.count + 1
        return totalNumberOfCells % 2 == 0 ? totalNumberOfCells/2: totalNumberOfCells/2 + 1
        */
        return 1
 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
        let totalNumberOfCells = previousCodes.count + 1
        if totalNumberOfCells % 2 == 0 {
            return 2
        }
        else {
            let numberOfSections = Int(totalNumberOfCells/2) + 1
            return section == numberOfSections - 1 ? 1 : 2
        }
        */
        return previousCodes.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellHeight = (self.collectionView.frame.height - 40) / CGFloat(2)
        let cellWidht = (self.collectionView.frame.width - 40) / CGFloat(2)
 
        if indexPath.section == 0 && indexPath.row == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as? ProgramNewCodeViewModel {
                
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht),
                ])
                
                cell.delegate = self
                
                return cell
            }
            
        }else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProgramViewModel {
                let index = indexPath.section * 2 + indexPath.row - 1
                
                cell.configureView(codeModel: previousCodes[index])
                
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht),
                ])
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

extension ProgramScreenVC: AddNewProgramProtocol{
    func addNewProgram() {
        (self.coordinator as! ProgramsCoordinator).openScreen(screenName: .CodingScreen)
    }

}

