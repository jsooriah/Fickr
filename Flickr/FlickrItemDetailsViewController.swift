//
//  FlickrItemDetailsViewController.swift
//  Flickr
//
//  Created by Joel Sooriah on 16/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

class FlickrItemDetailsViewController: UIViewController, UISearchBarDelegate {
	
	@IBOutlet fileprivate weak var tableView: UITableView!
	
	var flickrItem: FlickrFeedItem!
	
	var dataSource:FlickrItemDetailsDataSource?
	
	override func viewDidLoad() {
		      
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		configureTableView()
		print(flickrItem)
        dataSource?.update(withFlickrItem: flickrItem)
        title = "\((self.flickrItem?.title)! as String)"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

private extension FlickrItemDetailsViewController {
	
	func configureTableView() {
		
		tableView.register(UINib(nibName: FlickrItemSimpleLabelTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FlickrItemSimpleLabelTableViewCell.reuseIdentifier)
		tableView.register(UINib(nibName: FlickrItemDetailPhotoTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FlickrItemDetailPhotoTableViewCell.reuseIdentifier)
		
		tableView.estimatedRowHeight = 83
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.separatorStyle = .none
		
		dataSource = FlickrItemDetailsDataSource(tableView: tableView)
		tableView.delegate = dataSource
		tableView.dataSource = dataSource
	}
}


