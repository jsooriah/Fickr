//
//  ViewController.swift
//  Flickr
//
//  Created by Joel Sooriah on 13/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet fileprivate weak var tableView: UITableView!
	fileprivate var flickrItemDataSource: FlickrItemDataSource!
	
	override func viewDidLoad() {
		   
		super.viewDidLoad()
		
		setupTableView()
		
		// Do any additional setup after loading the view, typically from a nib.
		
		let apiClient = FlickrApiClient(language: "en-us")
		apiClient.fetchFeed(withTags: ["blue"], onSuccess: { flickrFeed in
			print(flickrFeed)
			self.flickrItemDataSource.update(withFlickrFeed: flickrFeed)
		}) { error in
			print(error.localizedDescription)
		}
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

