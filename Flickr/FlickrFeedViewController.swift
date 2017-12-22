//
//  ViewController.swift
//  Flickr
//
//  Created by Joel Sooriah on 13/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import UIKit

class FlickrFeedViewController: UIViewController, UISearchBarDelegate {
	
	@IBOutlet fileprivate weak var collectionView: UICollectionView!
	fileprivate var flickrItemDataSource: FlickrItemDataSource!
    
	var searchController: UISearchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		   
		super.viewDidLoad()
		
		setupCollectionView()
		setNavItems()
		loadFlickrFeed(withTags: [])
	}
	
	func loadFlickrFeed(withTags tags:[String]) {
		
		let apiClient = FlickrApiClient(language: "en-us") // use enum here
		apiClient.fetchFeed(withTags: tags, onSuccess: { flickrFeed in
			print(flickrFeed)
			self.flickrItemDataSource.update(withFlickrFeed: flickrFeed)
		}) { error in
			print(error.localizedDescription)
		}
		if (self.searchController.isActive) {
			self.searchController.dismiss(animated: true, completion: nil)
		}
	}
	
	func setNavItems() {
		let sortItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.organize, target: self, action: #selector(self.sortButtonTapped))
        self.navigationItem.leftBarButtonItem = sortItem
		let searchItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(searchButtonTapped))
		self.navigationItem.rightBarButtonItem = searchItem;
	}
	
    // MARK: Sort Actions
    
    func sortButtonTapped() {
		let actionSheet = UIAlertController(title: Config.FeedSort.ActionLabelStrings.SORT_ACTIONSHEET_TITLE, message: "", preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: Config.FeedSort.ActionLabelStrings.SORT_ACTIONSHEET_PUBLISHED_DATE_ACTION, style: .default, handler: { _ in
            self.flickrItemDataSource.sortBy(criteria: .publishedDate)
		}))
		actionSheet.addAction(UIAlertAction(title: Config.FeedSort.ActionLabelStrings.SORT_ACTIONSHEET_TAKEN_DATE_ACTION, style: .default, handler: { _ in
            self.flickrItemDataSource.sortBy(criteria: .takenDate)
		}))
		actionSheet.addAction(UIAlertAction(title: Config.FeedSort.ActionLabelStrings.SORT_ACTIONSHEET_CANCEL_ACTION, style: .cancel, handler: nil))
		self.present(actionSheet, animated: true, completion: nil)
    }
	
	func searchButtonTapped() {
		
        self.collectionView?.setContentOffset(.zero, animated: true)
        
		// Create the search controller and specify that it should present its results in this same view
		searchController = UISearchController(searchResultsController: nil)
		
		// Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
		
		// Make this class the delegate and present the search
		self.searchController.searchBar.delegate = self
		present(searchController, animated: true, completion: nil)
	}
	
	// called when keyboard search button pressed
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let tagsArray = searchBar.text?.components(separatedBy: ",")
		loadFlickrFeed(withTags: tagsArray!)
	}
	
	// MARK: setup Collection View
    
	fileprivate func setupCollectionView() {
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        
		collectionView.layoutMargins = .zero
		let nib = UINib(nibName: FlickrItemTableViewCell.nibName, bundle: nil)
		collectionView.register(nib, forCellWithReuseIdentifier: FlickrItemTableViewCell.reuseIdentifier)
        flickrItemDataSource = FlickrItemDataSource(collectionView: collectionView)
		flickrItemDataSource.viewControllerDelegate = self
		collectionView.dataSource = flickrItemDataSource
		collectionView.delegate = flickrItemDataSource
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let flickrItemDetailsVC = segue.destination as? FlickrItemDetailsViewController {
                flickrItemDetailsVC.flickrItem = sender as! FlickrFeedItem!
            }
        }
	}
}

