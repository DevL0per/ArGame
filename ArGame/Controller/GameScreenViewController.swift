//
//  GameScreenViewController.swift
//  ArGame
//
//  Created by Роман Важник on 27/10/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

final class GameScreenViewController: UIViewController, ARSCNViewDelegate {
    
    private var sceneView: ARSCNView!
    
    // Player score
    private var scoreLabel: UILabel!
    private var score = 1 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var shotButton: UIButton!
    private var aimImage: UIImageView!
    private var targetBox: Box!
    
    //shot sounds
    private var audioPlayer: AVAudioPlayer!
    private let shotSoundPath = Bundle.main.path(forResource: "shotSound.mp3", ofType: nil)!
    
    private var timer = Timer()
    // Start time counting
    private var startTime = 3 {
        didSet {
            startTimeLabel.text = "\(startTime)"
        }
    }
    private var startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    // Play time
    private var timeLabel: UILabel!
    private var counter = 30 {
        didSet {
            timeLabel.text = "time remain: \(counter)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure sceneView
        sceneViewConfigure()
        
        // configure main interface
        buttonConfigure()
        aimImageConfigure()
        scoreLabelsConfigure()
        runStartTimeCounter()
        timeLabelConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ScoreViewController
        vc.score = score
    }
    
    private func sceneViewConfigure() {
        sceneView = ARSCNView()
        view.addSubview(sceneView)
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sceneView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sceneView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
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
    
    private func runStartTimeCounter() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimerTarget), userInfo: nil, repeats: true)
        view.addSubview(startTimeLabel)
        shotButton.isUserInteractionEnabled = false
        
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        startTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func startTimerTarget() {
        startTime-=1
        if startTime == 0 {
            startTimeLabel.text = "START"
            shotButton.isUserInteractionEnabled = true
            timer.invalidate()
            gameTimerConfigure()
            UIView.animate(withDuration: 2) { [weak self] in
                self?.startTimeLabel.alpha = 0
            }
        }
    }
    
    private func gameTimerConfigure() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self,
        selector: #selector(gameTimerAction),
        userInfo: nil,
        repeats: true)
    }
    
    @objc private func gameTimerAction() {
        deleteBoxFromParentNode()
        let positionX = Float.random(in: -0.5...0.5)
        let positionY = Float.random(in: -0.5...0.5)
        let location = SCNVector3(positionX, positionY, -1)
        self.createTargetBox(in: location)
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
    
    private func createTargetBox(in positon: SCNVector3) {
        let startPosition = positon
        targetBox = Box(position: startPosition)
        sceneView.scene.rootNode.addChildNode(targetBox)
    }
    
    @objc private func shot() {
        
        let url = URL(fileURLWithPath: shotSoundPath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("can't load sound")
        }
        
        guard targetBox != nil else { return }
        
        let location = CGPoint(x: sceneView.center.x, y: sceneView.center.y)
        
        let hitTestResult = sceneView.hitTest(location, options: [:])
        guard let _ = hitTestResult.first else { return }
        score+=1
        
        deleteBoxFromParentNode()
        
    }
    
    private func deleteBoxFromParentNode() {
        guard targetBox != nil else { return }
        SCNTransaction.animationDuration = 2.0
        targetBox.opacity = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
            self?.targetBox.removeFromParentNode()
            self?.targetBox = nil
        }
    }
    
    private func buttonConfigure() {
        shotButton = UIButton()
        shotButton.backgroundColor = #colorLiteral(red: 0.7208914975, green: 0.7208914975, blue: 0.7208914975, alpha: 0.586124786)
        shotButton.layer.cornerRadius = 30
        shotButton.layer.borderWidth = 1
        shotButton.setImage(UIImage(named: "bullet"), for: .normal)
        view.addSubview(shotButton)
        
        shotButton.translatesAutoresizingMaskIntoConstraints = false
        shotButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        shotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shotButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        shotButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        shotButton.addTarget(self, action: #selector(shot), for: .touchUpInside)
    }
}
