//
//  FlickrItemSimpleLabelTableViewCell.swift
//  Flickr
//
//  Created by Joel Sooriah on 16/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

final class FlickrItemSimpleLabelTableViewCell: UITableViewCell {
	
	@IBOutlet fileprivate weak var contentLabel: UILabel?
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func setUpCell(forText text: String) {
        if let contentLabel_ = self.contentLabel as UILabel? {
			contentLabel_.text = text
		}
	}
}

