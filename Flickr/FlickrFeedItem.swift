//
//  FlickrFeedItem.swift
//  Flickr
//
//  Created by Joel Sooriah on 13/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

// This enum contains all the possible states a photo record can be in

enum PhotoRecordState {
	case New, Downloaded, Failed
}

class FlickrFeedItem : Object, Mappable {
	   
	dynamic var title:String? = nil
	dynamic var imageUrl:String? = nil
    dynamic var link:String? = nil
    dynamic var itemDescription:String? = nil
	dynamic var author:String? = nil
	dynamic var publishedDate:Date? = nil
	dynamic var takenDate:Date? = nil
	
	var state = PhotoRecordState.New
	dynamic var image:Data?
	
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
	
	func mapping(map: Map) {
		title <- map["title"]
        link <- map["link"]
        itemDescription <- map["description"]
        author <- map["author"]
		imageUrl <- map["media.m"]
        publishedDate <- (map["published"], DateTransform())
        takenDate <- (map["date_taken"], DateTransform())
	}
}



