//
//  HomeStackView.swift
//  MemoryCardGame
//
//  Created by user on 9/20/19.
//  Copyright © 2019 Abdel Rahman Ellithy. All rights reserved.
//

import UIKit

class HomeStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        distribution = .fillEqually
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .fill
        spacing = 32.0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

