//
//  StartScreenViewController.swift
//  ArGame
//
//  Created by Роман Важник on 26/10/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {

    private let iconImage: UIImageView! = {
        let image = UIImageView()
        image.image = UIImage(named: "appIcon")
        return image
    }()
    
    private let iconLabel: UILabel! = {
        let label = UILabel()
        label.text = "hit the target"
        label.font = UIFont(name: "Marker Felt", size: 23)
        return label
    }()
    
    private var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2513494194, green: 0.3505713046, blue: 0.4190593362, alpha: 1)
        mainLogoconfigure()
        startButtonConfigure()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    private func mainLogoconfigure() {
        let logoStackView = UIStackView()
        logoStackView.axis = .vertical
        logoStackView.alignment = .center
        logoStackView.spacing = 8
        
        logoStackView.addArrangedSubview(iconImage)
        logoStackView.addArrangedSubview(iconLabel)
        
        view.addSubview(logoStackView)
        logoStackView.translatesAutoresizingMaskIntoConstraints = false
        logoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func startButtonConfigure() {
        startButton = UIButton()
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 40)
        startButton.layer.cornerRadius = 5
        startButton.backgroundColor = #colorLiteral(red: 0.9387417436, green: 0.4307188392, blue: 0.3354183435, alpha: 1)
        startButton.titleLabel?.textColor = .white
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        startButton.addTarget(self, action: #selector(startButtonTarget), for: .touchUpInside)
    }
    
    @objc private func startButtonTarget() {
        performSegue(withIdentifier: "startGameSugue", sender: nil)
    }

}
