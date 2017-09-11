//
//  ViewController.swift
//  CoreAnimationDemo
//
//  Created by Luo, Yuyang on 6/9/17.
//  Copyright © 2017 Luo, Yuyang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var v: UIView!
    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self,
                                                                selector: #selector(yawVerticalLoop))

    private var perspectiveTransform: CATransform3D {
        var perspectiveTransform = CATransform3DIdentity
        perspectiveTransform.m34 = -1 / 8000
        return perspectiveTransform
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        v = generateDemoView()
        view.addSubview(v)
        
        startLoop()
    }
    
    private func generateDemoView() -> UIView {
        let screenWidth = view.frame.width
        let screenHeight = view.frame.height
        let demoViewWidth: CGFloat = 180
        let demoViewHeight: CGFloat = 180
        
        let frame = CGRect(x: screenWidth / 2 - demoViewWidth / 2,
                           y: screenHeight / 2 - demoViewHeight / 2,
                           width: demoViewWidth,
                           height: demoViewHeight)
        let v = UIView(frame: frame)
        
        let imageView = UIImageView(image: UIImage(named: "image.png"))
        imageView.frame = CGRect(x: 0, y: 0, width: demoViewWidth, height: demoViewHeight)
        v.addSubview(imageView)
        return v
    }
    
    private func startLoop() {
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        displayLink.preferredFramesPerSecond = 60
    }
    
    
    /******************* all the transformations *******************/
    
    private var verticalTranslationRate: CGFloat = 8
    @objc private func verticalLoop() {
        let bottomBorder = v.frame.maxY
        let topBorder = v.frame.minY
        if topBorder < 0 || bottomBorder > view.frame.height {
            verticalTranslationRate = -verticalTranslationRate
        }
        
        let transform = CATransform3DMakeTranslation(0, verticalTranslationRate, 0)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform)
    }
    
    private var horzTranslationRate: CGFloat = 3.8
    @objc private func horzLoop() {
        let leftBorder = v.frame.minX
        let rightBorder = v.frame.maxX
        if leftBorder < 0 || rightBorder > view.frame.width {
            horzTranslationRate = -horzTranslationRate
        }
        
        let transform = CATransform3DMakeTranslation(horzTranslationRate, 0, 0)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform)
    }
    
    private var depthTranslationRate: CGFloat = -0.08
    @objc private func depthTranslationLoop() {
        let transform = CATransform3DMakeTranslation(0, 0, depthTranslationRate)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform)
        v.layer.transform = CATransform3DConcat(v.layer.transform, perspectiveTransform)  // perspective
    }
    
    @objc private func yawLoop() {
        let transform = CATransform3DMakeRotation(0.08, 0, 0, -1)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform)
    }
    
    @objc private func rollLoop() {
        let transform = CATransform3DMakeRotation(0.08, 0, 1, 0)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform)
    }
    
    @objc private func pitchLoop() {
        let transform = CATransform3DMakeRotation(0.08, 1, 0, 0)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform)
    }
    
    @objc private func rollVerticalLoop() {  // try yaw + vertical in the same way
        let bottomBorder = v.frame.maxY
        let topBorder = v.frame.minY
        if topBorder < 0 || bottomBorder > view.frame.height {
            verticalTranslationRate = -verticalTranslationRate
        }
        
        let transform1 = CATransform3DMakeTranslation(0, verticalTranslationRate, 0)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform1)
        let transform2 = CATransform3DMakeRotation(0.08, 0, 0, 1)
        v.layer.transform = CATransform3DConcat(v.layer.transform, transform2)
    }
    
    var yawTransformation = CATransform3DIdentity
    var verticalTransformation = CATransform3DIdentity
    @objc private func yawVerticalLoop() {  // correct way to combine yaw & vertical
        let bottomBorder = v.frame.maxY
        let topBorder = v.frame.minY
        if topBorder < 0 || bottomBorder > view.frame.height {
            verticalTranslationRate = -verticalTranslationRate
        }
        
        let transform1 = CATransform3DMakeTranslation(0, verticalTranslationRate, 0)
        verticalTransformation = CATransform3DConcat(verticalTransformation, transform1)
        let transform2 = CATransform3DMakeRotation(0.08, 0, 0, 1)
        yawTransformation = CATransform3DConcat(yawTransformation, transform2)
        
        v.layer.transform = CATransform3DConcat(CATransform3DIdentity, yawTransformation)
        v.layer.transform = CATransform3DConcat(v.layer.transform, verticalTransformation)
    }
}

