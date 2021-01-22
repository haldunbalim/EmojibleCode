//
//  ClassStudentInfoViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 16.12.2020.
//

import UIKit

class ClassStudentInfoViewModel: UITableViewCell{
    let studentLabel = UILabel()
    let sumLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureStudentCell(name: String, surname: String){
        studentLabel.text = name + " " + surname
        studentLabel.textColor = .black
        studentLabel.font = .systemFont(ofSize: 17)
        studentLabel.translatesAutoresizingMaskIntoConstraints = false
        studentLabel.textAlignment = .left
        studentLabel.numberOfLines = 0
        
        self.addSubview(studentLabel)
        
        NSLayoutConstraint.activate([studentLabel.topAnchor.constraint(equalTo: self.topAnchor),
                                     studentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     studentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     studentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    func configureSumCell(sum: Int){
        sumLabel.text = "Number of students in the class".localized() + ": \(sum)"
        sumLabel.textColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
        sumLabel.font = .systemFont(ofSize: 17)
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.textAlignment = .center
        sumLabel.numberOfLines = 0
        
        self.addSubview(sumLabel)
        
        NSLayoutConstraint.activate([sumLabel.topAnchor.constraint(equalTo: self.topAnchor),
                                     sumLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     sumLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     sumLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    func configureNameCell(name: String, id: String){
        sumLabel.text = "Class name".localized() + ": " + name + "              " + "Class id".localized() + ": " + id
        sumLabel.textColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
        sumLabel.font = .systemFont(ofSize: 17)
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.textAlignment = .center
        sumLabel.numberOfLines = 0
        
        self.addSubview(sumLabel)
        
        NSLayoutConstraint.activate([sumLabel.topAnchor.constraint(equalTo: self.topAnchor),
                                     sumLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                     sumLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                     sumLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
}
