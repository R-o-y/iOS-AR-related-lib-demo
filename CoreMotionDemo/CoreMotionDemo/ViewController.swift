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
    private var rotationMatrix = CMRotationMatrix()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cmMotionManager.isDeviceMotionAvailable && !cmMotionManager.isDeviceMotionActive {
            
            cmMotionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main, withHandler: { (data, error) in
                if let deviceMotion = data {
                    
                    // demo1: print gravity in device coordinate
//                    print(String(format: "x: %.2f   y: %.2f   z: %.2f",
//                                 deviceMotion.gravity.x,
//                                 deviceMotion.gravity.y,
//                                 deviceMotion.gravity.z))
                    
                    
                    // demo2: print orientation angle
                    self.rotationMatrix = deviceMotion.attitude.rotationMatrix
                    print(String(format: "horz: %.2f   vert: %.2f   yaw: %.2f",
                                 self.getHorzAngleRelToNorth(),
                                 self.getVerticalAngle(),
                                 self.getYawAngle()))
                    
                }
            })

        }
    }
    
    
    /**************************************
    
    0. with device negative z point to North, device y face vertically up
    1. roll
    2. pitch
    3. yaw
    
    **************************************/
    
    
    /**
     0 degree: vertical
     positive direction: yaw right
     range: -pi ~ pi
     */
    func getYawAngle() -> Double {
        let deviceZ = Vector3D(x: rotationMatrix.m31, y: rotationMatrix.m32, z: rotationMatrix.m33)
        let deviceY = Vector3D(x: rotationMatrix.m21, y: rotationMatrix.m22, z: rotationMatrix.m23)
        
        // the horizontal vector perpendicular to the z-axis vector of the device
        let horzVectorPerpToDeviceZ = Vector3D(x: -(deviceZ.y), y: deviceZ.x, z: 0)
        
        // the normal vector of the surface spanned by the following 2 vectors:
        // - the z-axis vector of the device
        // - horzVectorPerpToDeviceZ
        let normalVector = horzVectorPerpToDeviceZ.crossProduct(with: deviceZ)
        
        let yawCos = -deviceY.projectionLength(on: normalVector) / deviceY.length
        var yawSin = sqrt(1 - yawCos * yawCos)
        if deviceY * horzVectorPerpToDeviceZ < 0 {
            yawSin = -yawSin
        }
        
        return atan2(yawSin, yawCos)
    }
    
    /**
     0 degree: horizontal
     positive direction: pitch up
     range: -pi/2 ~ pi/2
     */
    func getVerticalAngle() -> Double {
        let m33 = -rotationMatrix.m33
        return atan2(m33, sqrt(1 - m33 * m33))
    }
    
    /**
     0 degree: back pointing to true north
     positive direction: roll left
     range: -pi ~ pi
     */
    func getHorzAngleRelToNorth() -> Double {  // "RelTo": relative to
        return atan2(-rotationMatrix.m32, -rotationMatrix.m31)
    }
}

