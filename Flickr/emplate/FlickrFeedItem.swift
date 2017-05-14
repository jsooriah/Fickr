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

/*
 	title: "1390",
	link: "https://www.flickr.com/photos/146860704@N06/33793940484/",
	media: {
    	m: "https://farm5.staticflickr.com/4160/33793940484_477c5014c9_m.jpg"
	},
	date_taken: "2017-05-13T12:44:49-08:00",
	description: " <p><a href="https://www.flickr.com/people/146860704@N06/">Talat Oncu Mezat Veri Tabanı</a> posted a photo:</p> <p><a href="https://www.flickr.com/photos/146860704@N06/33793940484/" title="1390"><img src="https://farm5.staticflickr.com/4160/33793940484_477c5014c9_m.jpg" width="240" height="180" alt="1390" /></a></p> <p>Dosya adı: h:\mezatpazari\modamubadele\Images\Shop\7\Product\1165\1390.jpg</p>",
published: "2017-05-13T19:44:49Z",
	author: "nobody@flickr.com ("Talat Oncu Mezat Veri Taban\u0131")",
	author_id: "146860704@N06",
	tags: ""
*/

class FlickrFeedItem : Object, Mappable {
    
    dynamic var title:String? = nil
    dynamic var imageUrl:String? = nil
    
	var state = PhotoRecordState.New
	dynamic var image:Data?
	
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        title <- map["title"]
    }
}
