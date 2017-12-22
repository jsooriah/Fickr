//
//  Config.swift
//  Flickr
//
//  Created by Joel Sooriah on 21/12/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Foundation

struct Config {
	
	// Api
	struct Api {
		static let FLICKR_API_HOST: String = "https://api.flickr.com"
		static let PUBLIC_PHOTOS_PATH = "/services/feeds/photos_public.gne"
	}
    
    // Sort Feed
	struct FeedSort {
		struct ActionLabelStrings {
			static let SORT_ACTIONSHEET_TITLE = "Sort photos by :"
			static let SORT_ACTIONSHEET_PUBLISHED_DATE_ACTION = "1. Published date"
			static let SORT_ACTIONSHEET_TAKEN_DATE_ACTION = "2. Taken Date"
            static let SORT_ACTIONSHEET_CANCEL_ACTION = "Cancel"
		}
	}
    
    // Sort Feed Item
    struct Share {
        struct ActionLabelStrings {
            static let SHARE_ACTIONSHEET_TITLE = "Actions :"
            static let SHARE_ACTIONSHEET_SAVE_ACTION = "1. Save Photo"
            static let SHARE_ACTIONSHEET_SEND_ACTION = "2. Send Photo"
            static let SHARE_ACTIONSHEET_OPEN_BROWSER_ACTION = "3. Open In Browser"
            static let SHARE_ACTIONSHEET_CANCEL_ACTION = "Cancel"
        }
    }
}



