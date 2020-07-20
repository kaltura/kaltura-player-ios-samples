//
//  CircleProgressView.swift
//  OTTSample
//
//  Created by Nilit Danan on 6/25/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircleProgressView: UIView {

    private var shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCirclePath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCirclePath()
    }
    
    private func createCirclePath() {
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let radius = min(frame.size.width / 2.0, frame.size.height / 2.0)
        let circlePath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circlePath.cgPath
        
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 3.0
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        trackLayer.position = center
        
        layer.addSublayer(trackLayer)
        
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.position = center
        
        shapeLayer.transform = CATransform3DMakeRotation(-.pi / 2, 0, 0, 1)
        
        shapeLayer.strokeEnd = 0

        layer.addSublayer(shapeLayer)
    }

    func progressAnimation(toValue: Float) {
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = CGFloat(toValue)
        }
    }
}
