//
//  ExploreService.swift
//  News
//
//  Created by Maryam Kaveh on 2/16/1403 AP.
//

import Foundation
import Combine
import Alamofire

protocol NewsServiceProtocol {
    func asyncFetch<T: Decodable>(endpoint: EndPointProviderProtocol, responseModel: T.Type) async throws -> T
    func combineFetch<T: Decodable>(endpoint: EndPointProviderProtocol, responseModel: T.Type) -> AnyPublisher<T, ApiError>
}

//GET https://newsapi.org/v2/headlines?q=Apple&from=2024-05-05&sortBy=popularity&apiKey=API_KEY
class NewsService: NewsServiceProtocol {
    
    @Published var allListings: NewsResponse?
    @Published var newsError: ApiError?
    var cancellables = Set<AnyCancellable>()
    
    var session : URLSession {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 300
        return URLSession(configuration: config)
    }

    
    func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw ApiError(message: "Invalid HTTP response!", errorCode: "0")
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiError(message: "Error decoding data!", errorCode: "1")
        }
    }
    
    func asyncFetch<T>(endpoint: EndPointProviderProtocol, responseModel: T.Type) async throws -> T where T : Decodable {
        do {
            let request = try endpoint.asURLRequest()
            let (data, response) = try await session.data(for: request)
            return try self.handleResponse(data: data, response: response)
            
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError(message: "Unknown API error \(error.localizedDescription)", errorCode: "0")
        }
    }
    
    func combineFetch<T>(endpoint: EndPointProviderProtocol, responseModel: T.Type) -> AnyPublisher<T, ApiError> where T : Decodable {
        
        do {
            let request = try endpoint.asURLRequest()
            return session.dataTaskPublisher(for: request)
                .tryMap { (data, response) in
                    return try self.handleResponse(data: data, response: response)
                }
                .mapError{
                    $0 as? ApiError ?? ApiError(message: "Unknown API error!", errorCode: "0")
                }
                .eraseToAnyPublisher()
            
        } catch let error as ApiError { // errors in asURLRequest()
            return AnyPublisher<T, ApiError>(Fail(error: error))
        } catch {
            return AnyPublisher<T, ApiError>(Fail(error: ApiError(message: "Unknown API error \(error.localizedDescription)", errorCode: "0")))
        }
    }
    
//    func alamofireFetch(completion: @escaping (Result<NewsResponse, AFError>) -> Void) {
//        AF.request("https://newsapi.org/v2/everything?q=Apple&from=2024-05-05&apiKey=3cd5c744843a417997f46098b820065a")
//            .validate()
//            .responseDecodable(of: NewsResponse.self, decoder: JSONDecoder()) { response in
//                print(response.result)
//                completion(response.result)
//            }
//    }
    

}
