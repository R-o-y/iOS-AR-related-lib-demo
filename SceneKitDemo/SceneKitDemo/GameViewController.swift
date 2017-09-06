//
//  GameViewController.swift
//  SceneKitDemo
//
//  Created by Luo, Yuyang on 4/9/17.
//  Copyright © 2017 Luo, Yuyang. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SceneKit.ModelIO

class GameViewController: UIViewController {
    let cameraNode = SCNNode()
    private let scene = SCNScene()
    private var scnView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scnView = SCNView(frame: view.frame)
        scnView.backgroundColor = UIColor.white
        view.addSubview(scnView)
        
        scnView.scene = scene
        setupCameraNode()
        
        let node = generateNode()!
        scene.rootNode.addChildNode(node)
        
        scnView.allowsCameraControl = true

        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    private func generateNode() -> SCNNode? {
        return SCNScene(named: "untitled2.dae")?.rootNode.childNode(withName: "PikachuM", recursively: true)
    }
    
    private func setupCameraNode() {
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        
        var transform = SCNMatrix4Rotate(SCNMatrix4Identity, -Float.pi/2, 0, 1, 0)
        transform = SCNMatrix4Rotate(transform, Float.pi/2, 1, 0, 0)
        cameraNode.transform = transform
        
        cameraNode.position = SCNVector3(x: -8, y: 0, z: 6)
        
        // pokemon face to negative x
        // camera face to negative z
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}



