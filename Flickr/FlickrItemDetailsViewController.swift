//
//  FlickrItemDetailsViewController.swift
//  Flickr
//
//  Created by Joel Sooriah on 16/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit
import Photos

class FlickrItemDetailsViewController: UIViewController, UISearchBarDelegate {
	
	@IBOutlet fileprivate weak var tableView: UITableView!
	var flickrItem: FlickrFeedItem!
	var dataSource:FlickrItemDetailsDataSource?
	
	// Todo & Remark :- Use programmatic UI View Controllers instead of Storyboards for clearer use of dependencies and avoid optionals !
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		configureTableView()
		setNavItems()
	}
	
	func setNavItems() {
		guard let flickrItem_ = self.flickrItem else { return }
		title = "\((flickrItem_.title)! as String)"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped))
	}
	
	func actionButtonTapped() {
		
		let actionSheet = UIAlertController(title: Config.Share.ActionLabelStrings.SHARE_ACTIONSHEET_TITLE, message: "", preferredStyle: .actionSheet)
		actionSheet.addAction(UIAlertAction(title: Config.Share.ActionLabelStrings.SHARE_ACTIONSHEET_SAVE_ACTION, style: .default, handler: { _ in
            self.savePhoto()
        }))
		actionSheet.addAction(UIAlertAction(title: Config.Share.ActionLabelStrings.SHARE_ACTIONSHEET_SEND_ACTION, style: .default, handler: { _ in
            self.sendPhoto()
        }))
		actionSheet.addAction(UIAlertAction(title: Config.Share.ActionLabelStrings.SHARE_ACTIONSHEET_OPEN_BROWSER_ACTION, style: .default, handler: { _ in
            self.openPhotoViaUrl()
        }))
		actionSheet.addAction(UIAlertAction(title: Config.Share.ActionLabelStrings.SHARE_ACTIONSHEET_CANCEL_ACTION, style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
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
		
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.separatorStyle = .none
		
		dataSource = FlickrItemDetailsDataSource(tableView: tableView)
        dataSource?.update(withFlickrItem: flickrItem)
		tableView.delegate = dataSource
		tableView.dataSource = dataSource
	}
}

private extension FlickrItemDetailsViewController {
	
	@objc func openPhotoViaUrl() {
		guard let urlString = self.flickrItem.link else { return }
		let url = URL(string: urlString)
		openSafariViewController(withURL: url!)
	}
	
	@objc func sendPhoto() {
		let configuration = MailConfiguration(recipients: ["joel.sooriah@gmail.com"], subject: "I wanted to share this photo with you, from Flickr.")
		sendMail(withConfiguration: configuration)
	}
    
    @objc func savePhoto() {
		guard let image = UIImage(data: flickrItem.image!) else { return }
		PHPhotoLibrary.shared().performChanges({
			PHAssetChangeRequest.creationRequestForAsset(from: image)
		}) { (success:Bool, error:Error?) in
			if success {
				print("Image Saved Successfully")
			} else {
				print("Error is saving:"+error.debugDescription)
			}
		}
	}
}




