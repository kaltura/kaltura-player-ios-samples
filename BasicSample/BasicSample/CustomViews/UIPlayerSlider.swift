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
    
    let bufferProgressView = UIProgressView(progressViewStyle: .default)
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }

    convenience init () {
        self.init(frame:CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        bufferProgressView.isUserInteractionEnabled = false
        bufferProgressView.progress = 0.0
        
        let layoutConstraints = bufferProgressView.constraintsForAnchoringTo(boundsOf: self)
//        NSLayoutConstraint.activate(layoutConstraints)
        
        self.addSubview(bufferProgressView)
    }
}

// MARK: -

extension UIView {

    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
}
