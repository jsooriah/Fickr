//
//  FlickrApiClient.swift
//  Flickr
//
//  Created by Joel Sooriah on 13/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum FlickrParameterKeys : String {
	case language = "lang"
	case format = "format"
	case tags = "tags"
	case tagmode = "tagmode"
    case nojsoncallback = "nojsoncallback"
}

enum FlickrParameterValues {
    
    enum ApiResponseFormat: String {
        case json = "json"
        case xml = "xml"
    }
    
    enum TagMode: String {
        case any = "any"
        case all = "all"
    }
    
    enum Language : String {
        
        case English = "en-us"
        case Italian = "it-it"
        case Spanish = "es-us"
        case German = "de-de"
        case Portuguese = "pt-br"
        case French = "fr-fr"
        case Chinese = "zh-hk"
    }
}

class FlickrApiClient {
	
	let baseURLString = "https://api.flickr.com/services/feeds/photos_public.gne"
	
	var params:Parameters =
		[
            FlickrParameterKeys.language.rawValue: FlickrParameterValues.Language.English.rawValue,
			FlickrParameterKeys.format.rawValue: FlickrParameterValues.ApiResponseFormat.json.rawValue,
			FlickrParameterKeys.tagmode.rawValue: FlickrParameterValues.TagMode.all.rawValue,
            FlickrParameterKeys.nojsoncallback.rawValue:"1"
    	]
	
	var language: FlickrParameterValues.Language = .English {
        didSet {
            params[FlickrParameterKeys.language.rawValue] = language.rawValue
        }
    }
	
	public init(language: String) {
		params[FlickrParameterKeys.language.rawValue] = language as AnyObject?
	}
}

typealias FlickrFeedCallback = (FlickrFeed) -> Void
typealias ErrorCallback = (NSError) -> Void

protocol FlickrApiFeed {
	func fetchFeed(withTags tags: [String], onSuccess: @escaping FlickrFeedCallback, onError: @escaping ErrorCallback)
}

extension FlickrApiClient: FlickrApiFeed {
    
	func fetchFeed(withTags tags: [String], onSuccess: @escaping FlickrFeedCallback, onError: @escaping ErrorCallback) {
		
		let urlString = self.baseURLString
        var parameters:Parameters = self.params
        parameters["tags"] = tags.joined(separator:",")
		
		Alamofire.request(urlString, parameters:parameters).validate().responseJSON { response in
			switch response.result {
			case .success:
				if let data = response.result.value {
					let res = Mapper<FlickrFeed>().map(JSONObject: data)
					onSuccess(res!)
				}
            case .failure(let error):
                onError(error as NSError)
            }
        }
    }
}











