//
//  CardsCollectionViewCell.swift
//  MemoryCardGame
//
//  Created by user on 9/20/19.
//  Copyright © 2019 Abdel Rahman Ellithy. All rights reserved.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell {
    
    var frontSide = UIImageView()
    var backSide = UIImageView()
    var selectedCardDarkView = UIView()
    var matched = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backSide)
        addSubview(frontSide)
        addSubview(selectedCardDarkView)
        
        initView(view: selectedCardDarkView)
        initConstraintsForImageView(imageView: frontSide)
        initConstraintsForImageView(imageView: backSide)
        frontSide.alpha = 0.0
        backSide.image = UIImage(named: "ShopifyLogo")
        
    }
    
    func flipToFront() {
        frontSide.alpha = CGFloat(1)
        
        UIView.transition(from: backSide, to: frontSide, duration: 0.2, options: [.transitionFlipFromTop, .showHideTransitionViews], completion: nil)
    }
    
    func flipToBack() {
        frontSide.alpha = CGFloat(0)
        
        UIView.transition(from: frontSide, to: backSide, duration: 0.2, options: [.transitionFlipFromTop, .showHideTransitionViews], completion: nil)
    }
    
    func matchedCard() {
        matched = true
        selectedCardDarkView.alpha = (1)
    }
    
    func initConstraintsForImageView(imageView : UIImageView) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    func initView(view : UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.0
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
