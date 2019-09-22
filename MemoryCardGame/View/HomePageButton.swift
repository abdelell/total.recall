//
//  HomePageButton.swift
//  MemoryCardGame
//
//  Created by user on 9/20/19.
//  Copyright © 2019 Abdel Rahman Ellithy. All rights reserved.
//


import UIKit

class HomePageButton: UIButton {
    
    required init(title: String = "") {
        super.init(frame: .zero)
        backgroundColor = UIColor(named: "Green")
        
        layer.cornerRadius = 24.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = true
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 25
        
        setTitleColor(.white, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font =  UIFont(name: "Helvetica", size: 20)
        translatesAutoresizingMaskIntoConstraints = false
        
        // height constraint
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50.0),
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
