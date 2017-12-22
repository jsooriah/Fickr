# Flickr App

This app fetch a feed from Flickr public api and allows user to search this feed by entering particular tags via a search ui component.
User can then view details of the one feed item, display photo, save the photo to library, send across email and open corresponding web url in
a browser.

# How to run

Launch app in XCode and run via simulator.

# Comments

Project makes use of Alamofire for network requests, Realm for caching.


# Unit tests

The project contains tests written with Nimble, Quick and MockingJay against the Network layer. MockingJay used to stub response from Flickr Api.

Run `CMD+U` in order to run tests

Tests Spec are speficied in FlickrApiClientTests.swift

# Improvements
- Implement UIViewControllers programmatically (rather than via storyboards) for better handling of dependencies and optionals, and also for better testability and code readability
- Fetch from database when no connectivity (Offline mode + Implement reachability check)
- Improve UI
  - Resize to fit description label
	- add display tags functionality on each flickr item cell
	- Save searched tags so as to implement recent searches functionality
	- Add loader and network activity when network busy
	- Complete mail configuration to attach image
	- Find appropriate image and put in assets folder for sort icon
	