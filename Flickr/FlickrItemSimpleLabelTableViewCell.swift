//
//  FlickrItemSimpleLabelTableViewCell.swift
//  Flickr
//
//  Created by Joel Sooriah on 16/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation

import Foundation
import UIKit

final class FlickrItemSimpleLabelTableViewCell: UITableViewCell {
	
	@IBOutlet fileprivate weak var contentLabel: UILabel!
	
	// MARK: Lifecycle
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func setUpCell(forText text: String) {
		self.contentLabel?.text = text
	}
}

