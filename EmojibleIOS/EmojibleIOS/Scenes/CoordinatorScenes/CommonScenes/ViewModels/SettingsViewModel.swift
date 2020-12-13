//
//  SettingsCellViewModel.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 13.12.2020.
//

import UIKit

class SettingsViewModel: UITableViewCell{
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLabel()
    }
    
    func configureLabel(){
        label.textColor = #colorLiteral(red: 0.007333596703, green: 0.2443790138, blue: 0.5489466786, alpha: 1)
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        self.addSubview(label)
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: self.topAnchor),
                                    label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                                    label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                                    label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10)])
    }
    
    func setLabel(text: String){
        label.text = text
    }
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
     */
}
