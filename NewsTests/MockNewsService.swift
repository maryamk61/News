//
//  ExploreService.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/3/1403 AP.
//

import Foundation
import Combine
@testable import News

class MockNewsService: NewsServiceProtocol {
    var allListings: News.NewsResponse?
    
    func asyncFetch<T>(endpoint: EndPointProviderProtocol, responseModel: T.Type) async throws -> T where T : Decodable {
        
            guard let data = readJsonFile() else {
               throw ApiError(message: "Error in reading from json file", errorCode: "1")
            }
            
            return try JSONDecoder().decode(T.self, from: data)
    }
    
    func combineFetch<T>(endpoint: EndPointProviderProtocol, responseModel: T.Type) -> AnyPublisher<T, ApiError> where T : Decodable {
        Thread.sleep(forTimeInterval: 1)
        do {
            guard let data = readJsonFile() else {
                return AnyPublisher<T, ApiError>(Fail(error: ApiError(message: "Error reading json file!", errorCode: "1")))
            }
            let json = try JSONDecoder().decode(T.self, from: data)
            return Just(json)
                .map({response in
                    return response
                })
                .mapError {error -> ApiError in
                    return ApiError(message: "Error reading json file!", errorCode: "1")
                }
                .eraseToAnyPublisher()
            
        } catch {
            return AnyPublisher<T, ApiError>(Fail(error: ApiError(message: "Unknown API error \(error.localizedDescription)", errorCode: "0")))
        }
    }
    
    private func readJsonFile() -> Data? {
        do {
            guard let url = Bundle(for: MockNewsService.self).url(forResource: "Articles", withExtension: "json") else {
                print("Json url invalid!!!")
                return nil
            }
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print(error)
            return nil
        }
        
    }
}

