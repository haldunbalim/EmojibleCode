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
    var tutorials: [CodeModel] = []
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .defaultTutorialsChanged, object: nil)
        TutorialDataSource.getInstance().startObservingDefaultTutorials()

    }
    
    @objc func notify(_ notification: NSNotification){
        guard let defaultTutorials = notification.userInfo?["defaultTutorials"] else { return }
        tutorials = defaultTutorials as! [CodeModel]
        collectionView.reloadData()
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "TutorialViewModel", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.TAB_BAR_WIDTH),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}


//MARK: - CollectionView methods

extension TutorialScreenVC: UICollectionViewDelegate{

}

extension TutorialScreenVC: UICollectionViewDelegateFlowLayout{

}

extension TutorialScreenVC: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorials.count
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
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TutorialViewModel {
        
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
extension TutorialScreenVC:TutorialTabButtonAction{
    func viewAction(title: String, code: String) {
        (self.coordinator as! TutorialsCoordinator).tutorialTitle = title
        (self.coordinator as! TutorialsCoordinator).tutorialCode = code
        (self.coordinator as! TutorialsCoordinator).openScreen(screenName: .TutorialCodeScreen)
    }
    
    func runAction(code:String) {
        /*
        guard let coordinator = self.coordinator as? TutorialsCoordinator else { return }
        coordinator.runningCode = code
        coordinator.openScreen(screenName: .RunScreen)
         */
        
        if let _ = self.coordinator?.parentCoordinator as? CommonCoordinator {
            CommonCoordinator.getInstance().runCode(code: code)
        }else if let _ = self.coordinator?.parentCoordinator as? StudentCoordinator {
            StudentCoordinator.getInstance().runCode(code: code)
        }else if let _ = self.coordinator?.parentCoordinator as? TeacherCoordinator{
            TeacherCoordinator.getInstance().runCode(code: code)
        }
    }
}


