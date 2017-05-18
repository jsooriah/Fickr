//
//  AppearanceConfigurator.swift
//  Flickr
//
//  Created by Joel Sooriah on 14/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

class AppearanceConfigurator {
	
	class func configureNavigationBar() {
		
		let attributes = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName : ColorPalette.black
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes
	}
}

