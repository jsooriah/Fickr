//
//  ViewController.swift
//  Flickr
//
//  Created by Joel Sooriah on 13/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		
		let apiClient = FlickrApiClient(language: "en-us")
		apiClient.fetchFeed(withTags: ["blue"], onSuccess: { flickrFeed in
			print(flickrFeed)
		}) { error in
			
		}
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

