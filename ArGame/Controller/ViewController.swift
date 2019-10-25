//
//  ViewController.swift
//  ArGame
//
//  Created by Роман Важник on 23/10/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    private var timer = Timer()
    
    private var scoreLabel: UILabel!
    private var score = 0
    
    private var timeLabel: UILabel!
    private var counter = 30 {
        didSet {
            timeLabel.text = "time remain: \(counter)"
        }
    }
    
    private var button: UIButton!
    private var aimImage: UIImageView!
    private var box: Box!
    
    private var audioPlayer: AVAudioPlayer!
    private let shotSoundPath = Bundle.main.path(forResource: "shotSound.mp3", ofType: nil)!
    
    let shotBundle = Bundle.main.path(forResource: "shotSound", ofType: "mp3")
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        buttonConfigure()
        aimImageConfigure()
        scoreLabelsConfigure()
        timeLabelConfigure()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func timeLabelConfigure() {
        timeLabel = UILabel()
        timeLabel.text = String("time remain: \(counter)")
        timeLabel.textColor = .black
        view.addSubview(timeLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: 30).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func scoreLabelsConfigure() {
        scoreLabel = UILabel()
        scoreLabel.text = String("score: \(score)")
        scoreLabel.textColor = .black
        view.addSubview(scoreLabel)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func timerConfigure() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self,
        selector: #selector(timerAction),
        userInfo: nil,
        repeats: true)
    }
    
    @objc private func timerAction() {
        deleteBoxFromParentNode()
        let positionX = Int.random(in: -1..<2)
        let positionY = Int.random(in: -1..<2)
        let location = SCNVector3(positionX, positionY, -1)
        self.createBox(in: location)
        counter-=2
        if counter == 0 {
            performSegue(withIdentifier: "scoreSegue", sender: nil)
        }
    }
    
    private func aimImageConfigure() {
        aimImage = UIImageView()
        aimImage.backgroundColor = .clear
        aimImage.image = UIImage(named: "aim")
        
        view.addSubview(aimImage)
        aimImage.translatesAutoresizingMaskIntoConstraints = false
        aimImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        aimImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aimImage.widthAnchor.constraint(equalToConstant: 15).isActive = true
        aimImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    private func createBox(in positon: SCNVector3) {
        let startPosition = positon
        box = Box(position: startPosition)
        sceneView.scene.rootNode.addChildNode(box)
    }
    
    private func shot() {
        
//        let url = URL(fileURLWithPath: shotSoundPath)
//
//               do {
//                   audioPlayer = try AVAudioPlayer(contentsOf: url)
//                   audioPlayer.play()
//               } catch {
//                   print("can't load sound")
//               }
        
        guard box != nil else { return }
        
        let location = CGPoint(x: sceneView.center.x, y: sceneView.center.y)
        
        let hitTestResult = sceneView.hitTest(location, options: [:])
        guard let _ = hitTestResult.first else { return }
        score+=1
        scoreLabel.text = String("score: \(score)")
        
        deleteBoxFromParentNode()
        
    }
    
    private func deleteBoxFromParentNode() {
        guard box != nil else { return }
        SCNTransaction.animationDuration = 2.0
        box.opacity = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            self?.box.removeFromParentNode()
            self?.box = nil
        }
    }
    
    private func buttonConfigure() {
        button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.7208914975, green: 0.7208914975, blue: 0.7208914975, alpha: 0.586124786)
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        button.setTitle("Start", for: .normal)
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        
        if button.titleLabel?.text == "Start" {
            button.setImage(UIImage(named: "bullet"), for: .normal)
            timerConfigure()
        } else {
            shot()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ScoreViewController
        vc.score = score
    }
}
