//
//  TeacherMainScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 2.11.2020.
//

import Foundation
import UIKit

private let reuseIdentifier = "TeacherTutorialScreenCell"
private let reuseIdentifier2 = "TeacherTutorialAddCell"
private let reuseIdentifier3 = "EmptyCell"

class TeacherTutorialScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    var previousTutorials: [CodeModel] = []
    
    var removeAlert: RemoveAlert!
    var tutorialToBeRemoved : CodeModel?
    
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
        configureRemoveAlert()
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .teacherTutorialsChanged, object: nil)
        TeacherTutorialDataSource.getInstance().startObservingTutorials()
    }
    
    @objc func notify(_ notification: NSNotification){
        guard let tutorialsFromDB = notification.userInfo?["teacherTutorialsChanged"] else { return }
        self.previousTutorials = tutorialsFromDB as! [CodeModel]
        collectionView.reloadData()
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "TeacherTutorialViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(UINib(nibName: "TeacherCodingScreenViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier2)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier3)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func configureRemoveAlert(){
        removeAlert = RemoveAlert()
        removeAlert.delegate = self
        removeAlert.removeTeacherTutorialDelegate = self
    }
    
    func trashButtonPressed(tutorial: CodeModel){
        self.tutorialToBeRemoved = tutorial
        self.removeAlert.presentOver(viewController: self)
    }
}

//MARK: - CollectionView methods

extension TeacherTutorialScreenVC: UICollectionViewDelegate{}

extension TeacherTutorialScreenVC: UICollectionViewDelegateFlowLayout{}

extension TeacherTutorialScreenVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previousTutorials.count == 0 ? 2: previousTutorials.count + 1
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
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as? TeacherCodingScreenViewModel {
                
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht)])
                
                cell.newTutorialDelegate = self
                
                return cell
            }
            
        }else {
            if previousTutorials.count == 0{
                return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath)
            }
            
            else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TeacherTutorialViewModel {
                
                cell.configureView(codeModel: previousTutorials[indexPath.row - 1])
                NSLayoutConstraint.activate([
                    cell.heightAnchor.constraint(equalToConstant: cellHeight),
                    cell.widthAnchor.constraint(equalToConstant: cellWidht)])
                
                cell.editDelegate = self
                cell.runDelegate = self
                cell.trashDelegate = self
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
}

//MARK: - Button action protocols
extension TeacherTutorialScreenVC: TeacherTutorialTabButtonAction{
    func newTutorialAction() {
        (self.coordinator as! TeacherTutorialCoordinator).openScreen(screenName: .CodingScreen)
    }
    
    func editAction(tutorialModel: CodeModel) {
        (self.coordinator as! TeacherTutorialCoordinator).tutorialModel = tutorialModel
        (self.coordinator as! TeacherTutorialCoordinator).openScreen(screenName: .SavedTutorialScreen)
    }
    
    func runAction() {
        
    }
    
    func trashAction(tutorialModel: CodeModel) {
        self.trashButtonPressed(tutorial: tutorialModel)
    }
}


extension TeacherTutorialScreenVC: TeacherTutorialRemovalAlert {}
