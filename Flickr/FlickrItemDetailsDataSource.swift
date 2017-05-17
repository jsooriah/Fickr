//
//  FlickrItemDetailsDataSource.swift
//  Flickr
//
//  Created by Joel Sooriah on 16/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

final class FlickrItemDetailsDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
	
	fileprivate weak var viewController: UIViewController?
	fileprivate weak var tableView: UITableView?
	fileprivate enum flickrItemDetails: Int {
		case header, title, author, description
	}
	
	var flickrItem:FlickrFeedItem?
	
	required init(tableView: UITableView) {
		self.tableView = tableView
		super.init()
	}
	
	func update(withFlickrItem flickrFeedItem: FlickrFeedItem?) {
		self.flickrItem = flickrFeedItem
		DispatchQueue.main.async {
			self.tableView?.reloadData()
		}
	}
	
	//MARK: UITableViewDelegate
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		switch flickrItemDetails(rawValue: (indexPath as NSIndexPath).row)! {
		case .header:
			guard cell is FlickrItemDetailPhotoTableViewCell else {
                fatalError("Unexpected cell type at \(indexPath)")
			}
        case .title:
            guard cell is FlickrItemSimpleLabelTableViewCell else {
                fatalError("Unexpected cell type at \(indexPath)")
            }
        case .author:
            guard cell is FlickrItemSimpleLabelTableViewCell else {
                fatalError("Unexpected cell type at \(indexPath)")
            }
        case .description:
			guard cell is FlickrItemSimpleLabelTableViewCell else {
				fatalError("Unexpected cell type at \(indexPath)")
			}
		}
	}
	
	// MARK: UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch flickrItemDetails(rawValue: (indexPath as NSIndexPath).row)! {
			case .header:
			let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemDetailPhotoTableViewCell
				cell.setUpCell(withImage: UIImage(data: (self.flickrItem?.image)!)!)
			return cell
			case .title:
			let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemSimpleLabelTableViewCell
            	cell.setUpCell(forText: "Title: \((self.flickrItem?.title)! as String)")
			return cell
        	case .author:
			let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemSimpleLabelTableViewCell
				cell.setUpCell(forText: "Author: \((self.flickrItem?.author)! as String)")
			return cell
        	case .description:
			let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemSimpleLabelTableViewCell
            	cell.setUpCell(forText: "Description: \((self.flickrItem?.itemDescription)! as String)")
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch flickrItemDetails(rawValue: (indexPath as NSIndexPath).row)! {
			case .header:
				return 220
        	case .title:
				return 60
        	case .author:
				return 60
        	case .description:
				return 180
		}
	}
}

