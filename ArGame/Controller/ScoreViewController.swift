//
//  ScoreViewController.swift
//  ArGame
//
//  Created by Роман Важник on 24/10/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet var scoreLabel: UILabel!
    var score: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text!+=" \(String(score))"

    }
    

}
