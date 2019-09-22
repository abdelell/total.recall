//
//  MainMenuViewController.swift
//  MemoryCardGame
//
//  Created by user on 9/18/19.
//  Copyright © 2019 Abdel Rahman Ellithy. All rights reserved.
//
import UIKit

enum Difficulty : Int {
    case Hard = 24
    case ExtremelyHard = 36
    case Impossible = 48
}

class MainMenuViewController: UIViewController {
    
    // huge Title
    let titleLabel = UILabel()
    
    // levels
    var levelStackView = HomeStackView()
    
    var hardLevelButton = HomePageButton(title: "Hard")
    var exHardLevelButton = HomePageButton(title: "Extremely Hard")
    var impossibleLevelButton = HomePageButton(title: "Impossible")
    
    // number of matches
    var matchesStackView = HomeStackView()
    
    var twoMatchesButton = HomePageButton(title: "2 Card Matches")
    var threeMatchesButton = HomePageButton(title: "3 Card Matches")
    var fourMatchesButton = HomePageButton(title: "4 Card Matches")
    
    var levelDifficulty = Difficulty.Hard
    var numOfCardMatches = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Game"
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        matchesStackView.alpha = 0.0
        levelStackView.alpha = 1.0
        UIStackView.transition(from: matchesStackView, to: levelStackView, duration: 0, options: [.transitionFlipFromTop, .showHideTransitionViews], completion: nil)
    }
    @objc func cardMatchesActions(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
            
        case 2:
            numOfCardMatches = 2
            
        case 3:
            numOfCardMatches = 3
            
        case 4:
            numOfCardMatches = 4
        default:
            break
        }
        
        presentGameViewController()
    }
    
    @objc func levelActions(_ sender: Any) {
        matchesStackView.alpha = CGFloat(1)
        
        // transition to the stackview with the number of card matches
        UIStackView.transition(from: levelStackView, to: matchesStackView, duration: 0.2, options: [.transitionFlipFromTop, .showHideTransitionViews], completion: nil)
        
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        // hard
        case 0:
            levelDifficulty = .Hard
        // extremely hard
        case 1:
            levelDifficulty = .ExtremelyHard
        // impossible
        case 2:
            levelDifficulty = .Impossible
        default:
            break
        }
    }
    func presentGameViewController() {
        let destinationVC = GameViewController()
        destinationVC.numOfCards = levelDifficulty.rawValue
        destinationVC.numOfMatches = numOfCardMatches
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
extension MainMenuViewController {
    // UI Setup Functions
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(matchesStackView)
        view.addSubview(levelStackView)
        view.addSubview(titleLabel)
        setupLevelBtns()
        setupMatchesBtns()
        setupTitle()
        stackViewsUI(levelStackView)
        matchesStackView.alpha = (0)
        stackViewsUI(matchesStackView)
    }
    
    func setupLevelBtns() {
        // hard Button
        hardLevelButton.tag = 0
        hardLevelButton.addTarget(self, action: #selector(levelActions(_:)), for: .touchUpInside)
        levelStackView.addArrangedSubview(hardLevelButton)
        
        // Extremely hard button
        exHardLevelButton.tag = 1
        exHardLevelButton.addTarget(self, action: #selector(levelActions(_:)), for: .touchUpInside)
        levelStackView.addArrangedSubview(exHardLevelButton)
        
        // Impossible Button
        impossibleLevelButton.tag = 2
        impossibleLevelButton.addTarget(self, action: #selector(levelActions(_:)), for: .touchUpInside)
        levelStackView.addArrangedSubview(impossibleLevelButton)
    }
    
    func setupMatchesBtns() {
        // 2 matches button
        twoMatchesButton.tag = 2
        twoMatchesButton.addTarget(self, action: #selector(cardMatchesActions(_:)), for: .touchUpInside)
        matchesStackView.addArrangedSubview(twoMatchesButton)
        
        // 3 matches button
        threeMatchesButton.tag = 3
        threeMatchesButton.addTarget(self, action: #selector(cardMatchesActions(_:)), for: .touchUpInside)
        matchesStackView.addArrangedSubview(threeMatchesButton)
        
        // 4 matches button
        fourMatchesButton.tag = 4
        fourMatchesButton.addTarget(self, action: #selector(cardMatchesActions(_:)), for: .touchUpInside)
        matchesStackView.addArrangedSubview(fourMatchesButton)
    }
    
    func stackViewsUI(_ stackView: UIStackView){
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50.0),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50.0)
            ])
        
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func setupTitle() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "total.recall"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Helvetica", size: 60)
        titleLabel.textColor = UIColor(named: "Green")
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50.0),
            ])
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
}

