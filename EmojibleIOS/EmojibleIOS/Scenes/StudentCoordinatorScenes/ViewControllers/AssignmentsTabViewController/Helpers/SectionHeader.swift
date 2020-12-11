//
//  SectionHeader.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 25.11.2020.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureLabel(){
        label.textColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        self.addSubview(label)
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: self.topAnchor),
                                    label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                    label.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
    }
    func setLabel(text: String){
        label.text = text
    }
}
