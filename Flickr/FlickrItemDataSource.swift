//
//  FlickrItemDataSource.swift
//  Flickr
//
//  Created by Joel Sooriah on 14/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

final class FlickrItemDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
	
	fileprivate var flickrFeed: FlickrFeed?
	fileprivate weak var tableView: UITableView?
	
	let pendingOperations = PendingOperations()
	
	required init(tableView: UITableView) {
		self.tableView = tableView
		super.init()
	}
	
	func update(withFlickrFeed flickrFeed: FlickrFeed?) {
        self.flickrFeed = flickrFeed
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard cell is FlickrItemTableViewCell else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
	}
    
	// MARK: UITableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.flickrFeed?.items != nil) ? (self.flickrFeed?.items?.count)! : 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: FlickrItemTableViewCell.reuseIdentifier) as? FlickrItemTableViewCell else {
			fatalError("Unexpected cell type at \(indexPath)")
		}
		cell.setUpCell(forObject: (self.flickrFeed?.items![indexPath.row])! as FlickrFeedItem)
		return cell
	}
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
    
    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        
        if let pathsArray = self.tableView?.indexPathsForVisibleRows {
            
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray )
            toBeCancelled.subtract(visiblePaths as Set<NSIndexPath>)
            
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations as Set<IndexPath>)
            
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }
            
            for indexPath in toBeStarted {
                let indexPath = indexPath as NSIndexPath
                let recordToProcess = self.flickrFeed?.items?[indexPath.row]
                startOperationsForPhotoRecord(photoDetails: recordToProcess!, indexPath: indexPath)
            }
        }
    }
    
	func startOperationsForPhotoRecord(photoDetails: FlickrFeedItem, indexPath: NSIndexPath) {
		startDownloadForRecord(photoDetails: photoDetails, indexPath: indexPath)
	}
	
	func startDownloadForRecord(photoDetails: FlickrFeedItem, indexPath: NSIndexPath){
		
		if pendingOperations.downloadsInProgress[indexPath] != nil {
			return
		}
        let downloader = ImageDownloader(flickrItem: photoDetails)
        downloader.completionBlock = {
			if downloader.isCancelled {
				return
			}
			DispatchQueue.main.async {
				self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
				self.tableView?.reloadRows(at: [indexPath as IndexPath], with: .fade)
			}
		}
		pendingOperations.downloadsInProgress[indexPath] = downloader
		pendingOperations.downloadQueue.addOperation(downloader)
	}
}








