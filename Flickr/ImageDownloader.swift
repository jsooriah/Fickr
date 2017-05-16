//
//  ImageDownloader.swift
//  Flickr
//
//  Created by Joel Sooriah on 14/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader: Operation {
	
	let flickrItem: FlickrFeedItem
	
	init(flickrItem: FlickrFeedItem) {
		self.flickrItem = flickrItem
	}
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
		let url = URL(string:self.flickrItem.imageUrl!)
		
		let imageData:Data = try! Data(contentsOf:url!)
		
		if self.isCancelled {
			return
		}
		
		if (imageData.count) > 0 {
			self.flickrItem.image = imageData
			self.flickrItem.state = .Downloaded
        } else {
            self.flickrItem.state = .Failed
			self.flickrItem.image = nil
		}
        
    }
}


