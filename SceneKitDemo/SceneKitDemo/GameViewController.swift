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
        return SCNScene(named: "untitled.dae")?.rootNode.childNode(withName: "PikachuM", recursively: true)
    }
    
    private func setupCameraNode() {
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: -6, y: 0, z: 18)
        // pokemon face to negative x
        // camera face to negative z, position at (0,0,0)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}



