//
//  Box.swift
//  ArGame
//
//  Created by Роман Важник on 23/10/2019.
//  Copyright © 2019 Роман Важник. All rights reserved.
//

import SceneKit
import ARKit

class Box: SCNNode {
    
    init(position: SCNVector3) {
        super.init()
        
        let firstMaterial = UIImage(named: "target")
        let secondMaterial = UIColor.white
        
        let geometry = SCNBox(width: 0.2, height: 0.2, length: 0.05, chamferRadius: 0.2)
        
        let sourceMaterials = [firstMaterial,
                               secondMaterial,
                               secondMaterial,
                               secondMaterial,
                               secondMaterial,
                               secondMaterial]
        
        let finalMaterials = sourceMaterials.map { sourceMaterial -> SCNMaterial in
            let material = SCNMaterial()
            material.diffuse.contents = sourceMaterial
            material.locksAmbientWithDiffuse = true
            return material
        }
        
        geometry.materials = finalMaterials
        self.geometry = geometry
        self.position = position
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
