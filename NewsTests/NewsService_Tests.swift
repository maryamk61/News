//
//  NewsTests.swift
//  NewsTests
//
//  Created by Maryam Kaveh on 3/1/1403 AP.
//

import XCTest
@testable import News
import Combine

@MainActor
final class NewsService_Tests: XCTestCase {

    var cancellable = Set<AnyCancellable>()
    var service: NewsService?
    
     override func setUpWithError() throws {
        service = NewsService()
    }

    override func tearDownWithError() throws {
       service = nil
    }

    func test_NewsService_combineFetch_shouldReturnItems() {
        var error: Error?
        var listings = [Article]()
        let expectation = XCTestExpectation(description: "Should return items after 10 seconds")
       
        service?.combineFetch(endpoint: NewsEndpoints.everything(queries: ["page":"1"]), responseModel: NewsResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            }, receiveValue: { item in
                listings = item.articles
            })
            .store(in: &cancellable)
        //then
        wait(for: [expectation], timeout: 10)
        XCTAssertNil(error)
        XCTAssertGreaterThan(listings.count , 0)
    }
    
    func test_NewsService_asyncFetch_shouldReturnItems() async {
        var listings = [Article]()
        let expectation = XCTestExpectation(description: "Should return items after 10 seconds")
       
        do {
            listings = try await service?.asyncFetch(endpoint: NewsEndpoints.everything(queries: ["page":"1"]), responseModel: NewsResponse.self).articles ?? []
        } catch {
           XCTFail()
        }
            
        //then
        XCTAssertGreaterThan(listings.count , 0)
    }

}
