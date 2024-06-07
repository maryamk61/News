//
//  ExploreViewModel_Tests.swift
//  NewsTests
//
//  Created by Maryam Kaveh on 3/8/1403 AP.
//

import XCTest
@testable import News
import Combine

@MainActor
final class ExploreViewModel_Tests: XCTestCase {
    var cancellable = Set<AnyCancellable>()
    var vm: ExploreViewModel?
    var bookmarkManager: BookmarkManager?
    
    override func setUpWithError() throws {
        bookmarkManager = BookmarkManager()
        vm = ExploreViewModel(service: NewsService(), bookmarkManager: bookmarkManager!)
    }

    override func tearDownWithError() throws {
        bookmarkManager = nil
        vm = nil
    }

    func test_ExploreViewModel_search_shouldChangeWhenSearchChanges() {
        guard let vm else {
            XCTFail()
            return
        }
        var listings = [Article]()
        let expectation = XCTestExpectation(description: "Should return items after 10 seconds")
        
        vm.$search
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertEqual($0, "google")
                expectation.fulfill()
            })
            .store(in: &cancellable)
        
        vm.search = "google"
    }
    
    func test_ExploreViewModel_favorites_shouldNotContainTitleInUserDefaults() {
        guard let bookmarkManager else {
            XCTFail()
            return
        }
       
        let title = "testtest"
        XCTAssertFalse(bookmarkManager.contains(title: title))
    }
    
    func test_ExploreViewModel_addOrRemove_shouldAddOrRemove() {
        guard let bookmarkManager else {
            XCTFail()
            return
        }
       
        bookmarkManager.titles = []
        let title = "testtest"
        bookmarkManager.addOrRemove(title: title)
        XCTAssertTrue(bookmarkManager.contains(title: title))
        
        bookmarkManager.addOrRemove(title: title)
        XCTAssertFalse(bookmarkManager.contains(title: title))
        
    }


}
