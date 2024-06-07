//
//  ٰEndpointProviderProtocol.swift
//  News
//
//  Created by Maryam Kaveh on 2/24/1403 AP.
//

import Foundation
import Alamofire

protocol EndPointProviderProtocol {
//        var scheme: String { get }
        var baseURL: String { get }
        var path: String { get }
        var method: RequestMethod { get }
//        var token: String { get }
        var api_key: String { get }
        var queryItems: [URLQueryItem]? { get }
        var body: [String: Any]? { get }
//        var mockFile: String? { get }
}

enum RequestMethod: String {
    case delete = "DELETE"
        case get = "GET"
        case post = "POST"
        case put = "PUT"
}

extension EndPointProviderProtocol {
//    var scheme: String { // 1
//           return "https"
//    }
    
    
//    var token: String { //3
//           return ApiConfig.shared.token?.value ?? ""
//       }
    
    var baseURL: String {
        return "https://newsapi.org"
    }
    
    var api_key: String {
        return "3cd5c744843a417997f46098b820065a"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents(string: baseURL)
//        components.scheme = scheme
//        components?.host = baseUrl
        components?.path = path
        if let queryItems = queryItems {
            components?.queryItems = queryItems
        }
    
        guard let url = components?.url else {
            throw ApiError(message: "URL Error!", errorCode: "0")
        }
       
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")

//        if !token.isEmpty {
//            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        
        if let body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw ApiError(message: "Error encoding http body", errorCode: "0")
            }
        }
        
        return urlRequest
    }

}

