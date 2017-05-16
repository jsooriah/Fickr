//
//  ViewController.swift
//  Flickr
//
//  Created by Joel Sooriah on 13/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
	
	@IBOutlet fileprivate weak var tableView: UITableView!
	fileprivate var flickrItemDataSource: FlickrItemDataSource!
    
	var searchController: UISearchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		   
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		
		setupTableView()
		setNavItems()
		
		loadFlickrFeed(withTags: ["London"])
	}
	
	func loadFlickrFeed(withTags tags:[String]) {
		
		let apiClient = FlickrApiClient(language: "en-us")
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
		let searchItem : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(searchButtonTapped))
		self.navigationItem.rightBarButtonItem = searchItem;
	}
	
	func searchButtonTapped() {
		
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
	
	// MARK: setup Table View
    
    fileprivate func setupTableView() {
		
		tableView.layoutMargins = .zero
		tableView.separatorInset = .zero
		let nib = UINib(nibName: FlickrItemTableViewCell.nibName, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: FlickrItemTableViewCell.reuseIdentifier)
		flickrItemDataSource = FlickrItemDataSource(tableView: tableView)
		tableView.dataSource = flickrItemDataSource
		tableView.delegate = flickrItemDataSource
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

