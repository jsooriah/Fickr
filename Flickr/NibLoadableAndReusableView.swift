//
//  NibLoadableView.swift
//  Flickr
//
//  Created by Joel Sooriah on 09/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadableView: class { }
extension NibLoadableView where Self: UIView {
	static var nibName: String {
		return String(describing: self)
	}
}

extension UICollectionViewCell: NibLoadableView { }
extension UICollectionViewCell: ReusableView { }

protocol ReusableView: class {}
extension ReusableView where Self: UIView {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}

extension UICollectionView {
	func register<T: UICollectionViewCell>(_: T.Type) {
		let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
	}
	func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
		}
		return cell
	}
}

extension UITableViewCell: NibLoadableView { }
extension UITableViewCell: ReusableView { }

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

