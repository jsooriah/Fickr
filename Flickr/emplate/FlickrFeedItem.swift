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

class FlickrFeedItem : Object, Mappable {
    
    dynamic var title:String? = nil
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        title <- map["title"]
    }
}
