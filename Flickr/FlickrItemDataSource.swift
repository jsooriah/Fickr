//
//  FlickrItemDataSource.swift
//  Flickr
//
//  Created by Joel Sooriah on 14/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class FlickrItemDataSource: NSObject {
	
	let pendingOperations = PendingOperations()
    
	weak var viewControllerDelegate:UIViewController?
    
	fileprivate var collectionView: UICollectionView
	
	fileprivate var flickrFeed: FlickrFeed? {
		didSet {
            guard let viewControllerDelegate_ = self.viewControllerDelegate, let flickrFeed_ = self.flickrFeed, let items = flickrFeed_.items else { return }
			viewControllerDelegate_.title = flickrFeed_.title
			flickrItems = items.sorted(by: { (lhsData, rhsData) -> Bool in
				return lhsData.publishedDate! < rhsData.publishedDate!
			})
		}
	}
	
	var flickrItems:[FlickrFeedItem]? {
		didSet {
			DispatchQueue.main.async {
                self.collectionView.setContentOffset(.zero, animated: true)
                self.collectionView.reloadData()
                self.collectionView.flashScrollIndicators()
				self.loadImagesForOnscreenCells()
			}
		}
	}
	
	required init(collectionView: UICollectionView) {
		self.collectionView = collectionView
		super.init()
	}
	
	func update(withFlickrFeed flickrFeed: FlickrFeed?) {
        self.flickrFeed = flickrFeed
        DispatchQueue.main.async {
            self.collectionView.reloadData()
			self.loadImagesForOnscreenCells()
        }
	}
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension FlickrItemDataSource : UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let flickrItems_ = self.flickrItems {
            return flickrItems_.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrItemTableViewCell.reuseIdentifier, for: indexPath) as! FlickrItemTableViewCell
        cell.contentView.alpha = 0
        
		if let flickrItems_ = self.flickrItems, let flickrItem = flickrItems_[indexPath.row] as FlickrFeedItem? {
            cell.setUpCell(forObject: flickrItem)
            if (!collectionView.isDragging && !collectionView.isDecelerating) {
                self.startDownloadForRecord(photoDetails: flickrItem, indexPath: indexPath as NSIndexPath)
            }
        }
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.8, animations: {
            cell.contentView.alpha = 1.0
        })
	}
}

extension FlickrItemDataSource : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let flickrItems_ = self.flickrItems, let flickrItem = flickrItems_[indexPath.row] as FlickrFeedItem? {
            self.viewControllerDelegate?.performSegue(withIdentifier: "showDetail", sender: flickrItem)
        }
    }
}

extension FlickrItemDataSource : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthHeight = collectionView.bounds.width/2 - 5
        return CGSize(width: widthHeight, height: widthHeight)
    }
}


// MARK:- Flickr Feed Sort Actions

enum SortCriteria {
    case takenDate
    case publishedDate
}

extension FlickrItemDataSource {
	
	func sortBy(criteria sortCriteria:SortCriteria) {
        guard let flickrFeed_ = self.flickrFeed, let items = flickrFeed_.items else { return }
		switch (sortCriteria) {
            case .publishedDate:
            	flickrItems = items.sorted(by: { (lhsData, rhsData) -> Bool in
                	return lhsData.publishedDate! < rhsData.publishedDate!
            	})
        	case .takenDate:
            	flickrItems = items.sorted(by: { (lhsData, rhsData) -> Bool in
                	return lhsData.takenDate! < rhsData.takenDate!
            	})
        }
	}
}

// MARK: - CollectionView Scrollview Delegate

extension FlickrItemDataSource {
    
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
}


// MARK: Image Operations

extension FlickrItemDataSource {
	
    func suspendAllOperations () {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations () {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells () {
        
		let pathsArray = self.collectionView.indexPathsForVisibleItems
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
            if let flickrItems_ = self.flickrItems, let recordToProcess = flickrItems_[indexPath.row] as FlickrFeedItem? {
                startOperationsForPhotoRecord(photoDetails: recordToProcess, indexPath: indexPath)
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
                self.collectionView.reloadItems(at: [indexPath as IndexPath])
            }
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}

