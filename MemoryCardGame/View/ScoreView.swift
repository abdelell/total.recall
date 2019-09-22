//
//  ScoreView.swift
//  MemoryCardGame
//
//  Created by user on 9/20/19.
//  Copyright © 2019 Abdel Rahman Ellithy. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    
    var scoreLabel = UILabel()
    var timerLabel = UILabel()
    var addOneLabel = UILabel()
    
    var timerCounter = 0.0
    var timer = Timer()
    
    var score = 0
    
    init(){
        super.init(frame: .zero)
        layer.borderWidth = 4.0
        layer.borderColor = UIColor(named: "Green")?.cgColor
        backgroundColor = .white
        frame.size.height = 80.0
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.masksToBounds = true
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 30

        setupLabels()
        labelConstraints()
    }
    
    func playerScored() {
        self.score += 1
        self.scoreLabel.text = "\(self.score)"
        
        self.addOneLabel.alpha = CGFloat(1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addOneLabel.alpha = CGFloat(0)
        }
        
    }
    
    @objc func updateTimer() {
        timerCounter += 0.1
        timerLabel.text = "\(String(format: "%.1f", timerCounter))s"
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setupLabels() {
        scoreLabel.text = "0"
        scoreLabel.defaultScoreLabelUI()
        timerLabel.text = "0s"
        timerLabel.defaultScoreLabelUI()
        addOneLabel.text = "+1"
        addOneLabel.alpha = 0.0
        addOneLabel.defaultScoreLabelUI()
        addOneLabel.font = UIFont(name: "Optima", size: 25)
        addOneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scoreLabel)
        addSubview(timerLabel)
        addSubview(addOneLabel)
        
    }
    func labelConstraints() {
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            addOneLabel.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 5)
            ])
        scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addOneLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UILabel {
    func defaultScoreLabelUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textAlignment = .center
        self.font = UIFont(name: "Optima", size: 52)
        self.textColor = UIColor(named: "Green")
    }
}
