//
//  UIPlayerSlider.swift
//  OTTSample
//
//  Created by Nilit Danan on 11/3/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit

@IBDesignable
class UIPlayerSlider: UISlider {
    
    lazy var bufferProgressView = UIProgressView(progressViewStyle: .default)
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }

    convenience init () {
        self.init(frame:CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBInspectable
    var bufferValue: Float = 0.0 {
        didSet {
            bufferProgressView.progress = bufferValue
        }
    }
    
    @IBInspectable
    var bufferTintColor: UIColor? {
        didSet {
            bufferProgressView.progressTintColor = bufferTintColor
        }
    }
    
    func setup() {
        bufferProgressView.frame = self.bounds
        bufferProgressView.progress = 0.0
        bufferProgressView.center = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.5)
        
        self.addSubview(bufferProgressView)
        self.sendSubviewToBack(bufferProgressView)

        // Constraints that make sure the progressview is at the Y center and equal width of this view.
        bufferProgressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bufferProgressView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bufferProgressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bufferProgressView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
