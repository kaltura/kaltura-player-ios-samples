//
//  UIMediaTableViewCell.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import Foundation
import UIKit
import KalturaPlayer

class UIMediaTableViewCell: UITableViewCell, MediaTableViewCell {
    @IBOutlet private weak var mediaLabel: UILabel!

    var videoData: VideoData? {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - UITableViewCell Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        
        videoData = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        mediaLabel.text = videoData?.title
    }
}
