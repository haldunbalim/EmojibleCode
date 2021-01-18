//
//  ClassScreenVC.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 12.11.2020.
//

import Foundation
import UIKit

private let reuseIdentifier = "TutorialScreenCell"
private let reuseIdentifier2 = "EmptyCell"

class ClassScreenVC: UIViewController, Coordinated{
    var coordinator: Coordinator?
    var tutorials: [CodeModel] = []
    
    var removeAlert: RemoveAlert!
    
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Class"
        self.navigationController?.navigationBar.isHidden = true
        configureTitleLabel()
        configureCollectionView()
        configureRemoveAlert()
        configureLanguage()
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .classTutorialChanged, object: nil)
        TeacherClassDataSource.getInstance().startObservingClassTutorials()
    }
    
    func configureLanguage(){
        leaveButton.setTitle("Leave".localized(), for: .normal)
    }
    
    @IBAction func leavePressed(_ sender: UIButton) {
        self.removeAlert.presentOver(viewController: self)
        self.removeAlert.deleteButton.setTitleColor(.red, for: .normal)
        self.removeAlert.deleteButton.setTitle("Leave".localized(), for: .normal)
    }
    
    @objc func notify(_ notification: NSNotification){
        guard let defaultTutorials = notification.userInfo?["classTutorialChanged"] else { return }
        tutorials = defaultTutorials as! [CodeModel]
        collectionView.reloadData()
    }
    
    func configureTitleLabel(){
        NSLayoutConstraint.activate([self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH + 10)])
        TeacherClassDataSource.getInstance().getClassName() { className in
            guard let className = className else {return}
            self.titleLabel.text = "You are in class".localized() + ": " + className
        }
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "TutorialViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier2)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    func configureRemoveAlert(){
        removeAlert = RemoveAlert()
        removeAlert.delegate = self
    }
}

//MARK: - CollectionView methods

extension ClassScreenVC: UICollectionViewDelegate{}

extension ClassScreenVC: UICollectionViewDelegateFlowLayout{}

extension ClassScreenVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tutorials.count == 1 {
            return 2
        }else {
            return tutorials.count
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cellHeight = (self.collectionView.frame.height + self.titleLabel.frame.height + 10 - 40) / CGFloat(2)
        let cellWidht = (self.collectionView.frame.width - 40) / CGFloat(2)
        
        
        if tutorials.count == 1 && indexPath.row == 1{
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath)
        }
        
        else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TutorialViewModel {
            cell.configureView(codeModel: tutorials[indexPath.row])
            NSLayoutConstraint.activate([
                cell.heightAnchor.constraint(equalToConstant: cellHeight),
                cell.widthAnchor.constraint(equalToConstant: cellWidht)])
            
            cell.viewDelegate = self
            cell.runDelegate = self
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
}

//MARK: - Button Action Protocols
extension ClassScreenVC:TutorialTabButtonAction{
    func viewAction(title: String, code: String) {
        (self.coordinator as! ClassCoordinator).tutorialTitle = title
        (self.coordinator as! ClassCoordinator).tutorialCode = code
        (self.coordinator as! ClassCoordinator).openScreen(screenName: .TutorialCodeScreen)
    }
    
    func runAction(code:String) {
        /*
        guard let coordinator = self.coordinator as? TutorialsCoordinator else { return }
        coordinator.runningCode = code
        coordinator.openScreen(screenName: .RunScreen)
         */
        StudentCoordinator.getInstance().runCode(code: code)
    }
}
