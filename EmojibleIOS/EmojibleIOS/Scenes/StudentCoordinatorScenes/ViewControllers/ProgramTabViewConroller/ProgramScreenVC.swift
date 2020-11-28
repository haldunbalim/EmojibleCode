//
//  CodingScreenVC.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 5.11.2020.
//

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
        configureNavigationBar()
        configureCollectionView()
    }
    
    func configureNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ProgramViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(UINib(nibName: "ProgramNewCodeViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier2)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

//MARK: - CollectionView methods

extension ProgramScreenVC: UICollectionViewDelegate{
    
}

extension ProgramScreenVC: UICollectionViewDelegateFlowLayout{
    
}

extension ProgramScreenVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previousCodes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellHeight = (self.collectionView.frame.height - 40) / CGFloat(2)
        let cellWidht = (self.collectionView.frame.width - 40) / CGFloat(2)

        if indexPath.row == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as? ProgramNewCodeViewModel {
                
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht)])
                
                cell.newCodeDelegate = self
                
                return cell
            }
            
        }else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProgramViewModel {
                
                cell.configureView(codeModel: previousCodes[indexPath.row - 1])
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht)])
                
                cell.editDelegate = self
                cell.runDelegate = self
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

//MARK: - Button action protocols
extension ProgramScreenVC: ProgramTabButtonAction{
    func newCodeAction() {
        (self.coordinator as! ProgramsCoordinator).openScreen(screenName: .CodingScreen)
    }
    
    func editAction(title: String, code: String) {
        (self.coordinator as! ProgramsCoordinator).programTitle = title
        (self.coordinator as! ProgramsCoordinator).programCode = code
        (self.coordinator as! ProgramsCoordinator).openScreen(screenName: .SavedCodeScreen)
    }
    
    func runAction() {
        
    }
    func trashAction() {
        
    }
}

