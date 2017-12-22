//
//  UIBarButtonItemExtension.swift
//  Flickr
//
//  Created by Joel Sooriah on 17/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
	
	class func sortButtonTarget(_ target: Any, action: Selector) -> UIBarButtonItem {
		let button:UIButton = UIButton(type:.custom)
		button.setImage(UIImage(named: "sort_icon"), for: UIControlState.normal)
		button.addTarget(target, action: action, for: .touchUpInside)
		button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButtonItem = UIBarButtonItem(customView: button)
		return barButtonItem
	}
}
