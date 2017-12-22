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
        func rowHeight() -> CGFloat? {
            switch self {
            case .header: return 220
            case .title: return 60
            case .author: return 60
            case .description: return 180
            }
        }
        static func count() -> Int { return flickrItemDetails.description.rawValue + 1 }
	}
	
	var flickrItem:FlickrFeedItem?
	
	required init(tableView: UITableView) {
		self.tableView = tableView
		super.init()
	}
	
	func update(withFlickrItem flickrFeedItem: FlickrFeedItem?) {
		
		if let flickrFeedItem_ = flickrFeedItem {
        	self.flickrItem = flickrFeedItem_
			DispatchQueue.main.async {
				self.tableView?.reloadData()
			}
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
		return flickrItemDetails.count()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let flickrItem_ = self.flickrItem else { return UITableViewCell() }
		switch flickrItemDetails(rawValue: (indexPath as NSIndexPath).row)! {
			case .header:
				let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemDetailPhotoTableViewCell
            	if let data = flickrItem_.image {
                	cell.setUpCell(withImage: UIImage(data: data)!)
            	}
				return cell
			case .title:
				let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemSimpleLabelTableViewCell
            	cell.setUpCell(forText: "Title: \((flickrItem_.title)! as String)")
				return cell
        	case .author:
				let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemSimpleLabelTableViewCell
				cell.setUpCell(forText: "Author: \((flickrItem_.author)! as String)")
				return cell
        	case .description:
				let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FlickrItemSimpleLabelTableViewCell
            	cell.setUpCell(forText: "Description: \((flickrItem_.itemDescription)! as String)")
				return cell
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return flickrItemDetails(rawValue: (indexPath as NSIndexPath).row)!.rowHeight()!
	}
}

