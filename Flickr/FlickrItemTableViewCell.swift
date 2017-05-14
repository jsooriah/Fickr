//
//  FlickrItemTableViewCell.swift
//  Flickr
//
//  Created by Joel Sooriah on 14/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

final class FlickrItemTableViewCell: UITableViewCell {
	
	@IBOutlet fileprivate weak var dateLabel: UILabel!
	@IBOutlet fileprivate weak var temperatureLabel: UILabel!
	@IBOutlet fileprivate weak var iconImageView: UIImageView!
	
	// MARK: Lifecycle
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	func setUpCell(forObject flickItem: FlickrFeedItem) {
		
		
	}
}


