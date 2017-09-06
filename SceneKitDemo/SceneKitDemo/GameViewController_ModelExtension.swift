//
//  GameViewController_ModelExtension.swift
//  SceneKitDemo
//
//  Created by Luo, Yuyang on 6/9/17.
//  Copyright © 2017 Luo, Yuyang. All rights reserved.
//

import SceneKit

extension GameViewController {
    
    public func generateNode2() -> SCNNode {
        let scaleFactor: Float = 0.18
        let pikachuNode = SCNScene(named: "untitled2.dae")?.rootNode.childNode(withName: "PikachuM", recursively: true)
        pikachuNode?.scale = SCNVector3(x: scaleFactor, y: scaleFactor, z: scaleFactor)
        pikachuNode?.position = SCNVector3(x: 0, y: -1.6, z: -2)
        return pikachuNode!
    }
    
    public func generateNode() -> SCNNode {
        let scaleFactor: Float = 0.008
        let pikachuNode = SCNScene(named: "untitled.dae")?.rootNode.childNode(withName: "PikachuM", recursively: true)
        pikachuNode?.scale = SCNVector3(x: scaleFactor, y: scaleFactor, z: scaleFactor)
        pikachuNode?.position = SCNVector3(x: 0, y: -1.6, z: -2)
        return pikachuNode!
    }
    
    public func generateCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        return cameraNode
    }
    
}
