//
//  ScoreViewController.swift
//  ArGame
//
//  Created by Роман Важник on 24/10/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    var score: Int!
    private var scoreLabel: UILabel!
    private var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2513494194, green: 0.3505713046, blue: 0.4190593362, alpha: 1)
        configureScoreLabel()
        configurefinishButton()

    }
    
    private func configureScoreLabel() {
        scoreLabel = UILabel()
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont(name: "Marker Felt", size: 55)
        view.addSubview(scoreLabel)
        scoreLabel.text = "Your score - \(score!)"
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configurefinishButton() {
        finishButton = UIButton()
        finishButton.setTitle("Finish", for: .normal)
        finishButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 40)
        finishButton.layer.cornerRadius = 5
        finishButton.backgroundColor = #colorLiteral(red: 0.9387417436, green: 0.4307188392, blue: 0.3354183435, alpha: 1)
        finishButton.titleLabel?.textColor = .white
        view.addSubview(finishButton)
        
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        finishButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        finishButton.addTarget(self, action: #selector(finishButtonTarget), for: .touchUpInside)
    }
    
    @objc private func finishButtonTarget() {
        performSegue(withIdentifier: "startScreenSegue", sender: nil)
    }

}
