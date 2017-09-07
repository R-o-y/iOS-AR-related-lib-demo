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
    private let scene = SCNScene()
    private var scnView: SCNView!
    private var cameraNode: SCNNode!
    private var pikachuNode: SCNNode!
    
    let motionManager = DeviceMotionManager.getInstance()
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(updateLoop))
    
    // for camera view
    let cameraViewController = CameraViewController()
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(cameraViewController)
        cameraViewController.setupCameraView()
        
        startObservingDeviceMotion()
        
        scnView = SCNView(frame: view.frame)
        scnView.backgroundColor = UIColor.clear
        scnView.scene = scene
        view.addSubview(scnView)
        
        cameraNode = generateCameraNode()
        scene.rootNode.addChildNode(cameraNode)
        
        pikachuNode = generateNode()
        scene.rootNode.addChildNode(pikachuNode)

        enableJumpingInteraction()
    }

    private func startObservingDeviceMotion() {
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        displayLink.preferredFramesPerSecond = 60
    }
    
    @objc private func updateLoop() {
        let pitch = motionManager.getVerticalAngle()
        let yaw = motionManager.getYawAngle()
        let roll = motionManager.getHorzAngleRelToNorth()
        
        // Note: the transfomation concatenation is the reversed order
        var transform = SCNMatrix4Rotate(SCNMatrix4Identity, Float(-yaw), 0, 0, 1)
        transform = SCNMatrix4Rotate(transform, Float(pitch), 1, 0, 0)
        transform = SCNMatrix4Rotate(transform, Float(roll), 0, 1, 0)
        transform = SCNMatrix4Translate(transform, 0, 1.6, 0)
        
        cameraNode.transform = transform
    }
    
    /********************* enable jumping interaction **************************/
    private func enableJumpingInteraction() {
        pikachuNode?.physicsBody = SCNPhysicsBody(
            type: .dynamic,
            shape: SCNPhysicsShape(geometry: SCNBox(width: 10, height: 0,
                                                    length: 10, chamferRadius: 0),
                                   options: nil)
        )
        pikachuNode?.physicsBody?.restitution = 0.8
        
        scene.rootNode.addChildNode(generateGroundNode())
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        
        var hitPikachu = false
        for result in hitResults {
            if result.node.name == "pikachu" {
                hitPikachu = true
            }
        }
        // check that we clicked on at least one object
        if hitPikachu {
            pikachuNode.physicsBody?.applyForce(SCNVector3(x: 0, y: 3.8, z: 0), asImpulse: true)
        }
    }
}



