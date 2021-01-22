//
//  TeacherClassViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 15.12.2020.
//

import UIKit


class TeacherClassViewModel: UITableViewCell{
    let classButton = UIButton()
    let createButton = UIButton()
    let trashButton = UIButton()
    
    var trashDelegate: TeacherClassTabButtonAction?
    var openClassDelegate:TeacherClassTabButtonAction?
    var newClassDelegate: TeacherClassTabButtonAction?
    
    var classroom: ClassModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureClassCell(classroom: ClassModel){
        self.classroom = classroom
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 0, weight: .regular, scale: .large)
        trashButton.setImage(UIImage(systemName: "trash", withConfiguration: configuration), for: .normal)
        trashButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        trashButton.titleLabel?.textAlignment = .center
        trashButton.tintColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.addTarget(self, action: #selector(trashButtonAction), for: .touchUpInside)
        self.addSubview(trashButton)
        NSLayoutConstraint.activate([
                                    trashButton.topAnchor.constraint(equalTo: self.topAnchor),
                                     trashButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     trashButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
                                     trashButton.widthAnchor.constraint(equalToConstant: 40)])
        
        let clasTitle = "Class name".localized() + ": " + classroom.className + "               " + "Class id".localized() + ": " + classroom.id
        
        classButton.setTitle(clasTitle, for: .normal)
        classButton.titleLabel?.font = .systemFont(ofSize: 17)
        classButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        classButton.titleLabel?.textAlignment = .center
        classButton.contentHorizontalAlignment = .center
        classButton.translatesAutoresizingMaskIntoConstraints = false
        classButton.addTarget(self, action: #selector(classButtonAction), for: .touchUpInside)
        self.addSubview(classButton)
        NSLayoutConstraint.activate([classButton.topAnchor.constraint(equalTo: self.topAnchor),
                                     classButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     classButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     classButton.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor)])
    }
    
    func configureCreateButton(){
        createButton.setTitle("Create new class".localized(), for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 17)
        createButton.setTitleColor(#colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1), for: .normal)
        createButton.titleLabel?.textAlignment = .center
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
        self.addSubview(createButton)
        NSLayoutConstraint.activate([createButton.topAnchor.constraint(equalTo: self.topAnchor),
                                     createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     createButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     createButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)])
    }
     
    @objc func createButtonAction(){
        self.newClassDelegate?.newClassAction()
    }
    
    @objc func trashButtonAction(){
        if let classroom = self.classroom{
            self.trashDelegate?.trashAction(classroom: classroom)
        }else{
            return
        }
    }
    
    @objc func classButtonAction(){
        if let classroom = self.classroom{
            self.openClassDelegate?.openClassAction(classroom: classroom)
        }else{
            return
        }
    }
}
