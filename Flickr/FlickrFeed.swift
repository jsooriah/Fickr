//
//  FlickrFeed.swift
//  Flickr
//
//  Created by Joel Sooriah on 13/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class FlickrFeed : Object, Mappable {
	
	dynamic var title:String? = nil
	var items:List<FlickrFeedItem>? = nil
	
	required convenience init?(map: Map) {
		self.init()
		mapping(map: map)
	}
	
	func mapping(map: Map) {
		title <- map["title"]
		items <- (map["items"], ArrayTransform<FlickrFeedItem>())
	}
}

class ArrayTransform<T:RealmSwift.Object> : TransformType where T:Mappable {
    
    typealias Object = List<T>
    typealias JSON = Array<AnyObject>
    
    public func transformFromJSON(_ value: Any?) -> List<T>? {
        let result = List<T>()
        if let tempArr = value as! Array<AnyObject>? {
            for entry in tempArr {
                let mapper = Mapper<T>()
                let model : T = mapper.map(JSONObject:entry)!
                result.append(model)
            }
        }
        return result
    }
    
    func transformToJSON(_ value: List<T>?) -> Array<AnyObject>? {
        if ((value?.count)! > 0)
        {
            var result = Array<T>()
            for entry in value! {
                result.append(entry)
            }
            return result
        }
        return nil
    }
}
