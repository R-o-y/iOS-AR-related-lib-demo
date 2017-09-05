//
//  ViewController.swift
//  CoreMotionDemo
//
//  Created by Luo, Yuyang on 4/9/17.
//  Copyright © 2017 Luo, Yuyang. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    private let cmMotionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cmMotionManager.isDeviceMotionAvailable && !cmMotionManager.isDeviceMotionActive {
            
            cmMotionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main, withHandler: { (data, error) in
                if let deviceMotion = data {
                    print(deviceMotion.gravity)
                }
            })

        }
    }
    
}

