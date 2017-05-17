//
//  FlickrApiClientTests.swift
//  Flickr
//
//  Created by Joel Sooriah on 17/05/2017.
//  Copyright © 2017 Flickr. All rights reserved.
//

import Quick
import Nimble
import Mockingjay
@testable import Flickr

class FlickrApiClientTests : QuickSpec {
	
	override func spec() {
        
        super.spec()
        
        describe("fetch flickr feed for tags") {
            
            context("success") {
                
                it("returns FlickrFeed") {
                    
                    var returnedFlickrFeed: FlickrFeed?
                    let bundle = Bundle(for: type(of: self))
                    let path = bundle.path(forResource: "FlickrFeedJsonResponse", ofType: "json")!
                    let data = NSData(contentsOfFile: path)!
					
                    let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&lang=en-us&nojsoncallback=1&tagmode=all&tags=london"
                    
                    self.stub(uri(urlString), jsonData(data as Data))
					
                    let apiClient = FlickrApiClient(language: "en-us")
                    apiClient.fetchFeed(withTags: ["london"], onSuccess: {
                        flickrFeed in returnedFlickrFeed = flickrFeed}
                    ){ error in }
                    
					expect(returnedFlickrFeed).toEventuallyNot(beNil(), timeout: 20)
					expect(returnedFlickrFeed?.title) == "Recent Uploads tagged london"
                }
            }
            
            context("error") {
                
                it("returns error") {
                    
                    var returnedError: NSError?
                    let error = NSError(domain: "Error", code: 404, userInfo: nil)
					
                    let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&lang=en-us&nojsoncallback=1&tagmode=all&tags=london"
                    
                    self.stub(uri(urlString), failure(error))
                    
                    let apiClient = FlickrApiClient(language: "en-us")
                    apiClient.fetchFeed(withTags: ["london"], onSuccess: {_ in }) { error in returnedError = error}
                    expect(returnedError).toEventuallyNot(beNil())
                }
            }
        }
    }
}
