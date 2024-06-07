//
//  ExploreService.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/3/1403 AP.
//

import Foundation
import Combine

class MockExploreService {
        
    func fetchListings() throws -> AnyPublisher<NewsResponse, Error> {
        
        Thread.sleep(forTimeInterval: 2)
        return Just(DeveloperPreview.mockResponse)
            .tryMap( {response in
                guard response.status == "ok" else {
                    throw URLError(.badServerResponse)
                }
                return DeveloperPreview.mockResponse
            })
            .eraseToAnyPublisher()
    }
}

