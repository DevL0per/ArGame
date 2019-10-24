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

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var button: UIButton!
    var aimImage: UIImageView!
    var box: Box!
    
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
    
    private func createBox() {
        let startPosition = SCNVector3(0, 0, -1)
        box = Box(position: startPosition)
        sceneView.scene.rootNode.addChildNode(box)
    }
    
    private func shot() {
        
        let location = CGPoint(x: sceneView.center.x, y: sceneView.center.y)
        
        let hitTestResult = sceneView.hitTest(location, options: [:])
        guard let result = hitTestResult.first else { return }
        
        print(result)
    }
    
    private func buttonConfigure() {
        button = UIButton()
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        button.backgroundColor = .red
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        if button.titleLabel?.text == "Start" {
            button.setTitle("Shot", for: .normal)
            createBox()
        } else {
            shot()
        }
    }
}
