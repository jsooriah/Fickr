//
//  FlickrItemDetailPhotoTableViewCell.swift
//  Flickr
//
//  Created by Joel Sooriah on 16/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

final class FlickrItemDetailPhotoTableViewCell: UITableViewCell {
	
	@IBOutlet fileprivate weak var flickrItemImageView: UIImageView!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.flickrItemImageView.image = nil
	}
	
	func setUpCell(withImage image: UIImage) {
        self.flickrItemImageView.image = image
	}
}
