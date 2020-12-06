//
//  TabNavigationMenu.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 22.11.2020.
//

import UIKit

class TabNavigationMenu: UIView {
    
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [UITabBarItem], frame: CGRect) {
        self.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 0.7525274158, green: 0.8178007007, blue: 0.9784051776, alpha: 1)
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        
        for i in 0 ..< menuItems.count-1 {
            let itemHeight = self.frame.height / CGFloat(menuItems.count-1)
            let topAnchor = itemHeight * CGFloat(i)
            
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.tag = i
            
            self.addSubview(itemView)
            
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalToConstant:itemHeight),
                itemView.widthAnchor.constraint(equalTo: self.widthAnchor),
                
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                itemView.topAnchor.constraint(equalTo: self.topAnchor, constant: topAnchor),
            ])
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
    }
    
    func createTabItem(item: UITabBarItem) -> UIView {
        let tabBarItem = UIView(frame: CGRect.zero)
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        
        
        tabBarItem.tag = 11
        itemTitleLabel.tag = 12
        itemIconView.tag = 13
        
        
        itemTitleLabel.text = item.title
        itemTitleLabel.font = UIFont.systemFont(ofSize: 12)
        itemTitleLabel.textColor = .white // changing color to white
        itemTitleLabel.textAlignment = .left
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.clipsToBounds = true
        
        itemIconView.image = item.image!.withRenderingMode(.automatic)
        itemIconView.contentMode = .scaleAspectFit // added to stop stretching
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        tabBarItem.layer.backgroundColor = UIColor.clear.cgColor
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        NSLayoutConstraint.activate([
            itemIconView.heightAnchor.constraint(equalToConstant: 20),
            itemIconView.widthAnchor.constraint(equalToConstant: 20),
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.centerYAnchor.constraint(equalTo: tabBarItem.centerYAnchor, constant: 8),
            
            itemTitleLabel.topAnchor.constraint(equalTo:itemIconView.bottomAnchor,constant: 5),
            itemTitleLabel.centerXAnchor.constraint(equalTo: itemIconView.centerXAnchor),
            ])
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        return tabBarItem
    }
    
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(to: sender.view!.tag)
    }
    
    func switchTab(to: Int) {
        self.deactivateTab(tab: self.activeItem)
        self.activateTab(tab: to)
    }
        
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[tab]
        tabToActivate.alpha = 0.5
        
        self.itemTapped?(tab)
        self.activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        inactiveTab.alpha = 1
    }
}

