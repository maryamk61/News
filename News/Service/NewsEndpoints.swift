//
//  NewsEndpoints.swift
//  News
//
//  Created by Maryam Kaveh on 2/24/1403 AP.
//

import Foundation

enum NewsEndpoints: EndPointProviderProtocol {
    
    var body: [String : Any]? {
        return nil
    }
    
    case everything(queries: [String: String])
    case headlines(queries: [String: String])

    var path: String {
        switch self {
        case .everything:
            return "/v2/everything"
        case .headlines:
            return "/v2/top-headlines"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .everything(let queries):
            var items = [
                         URLQueryItem(name: "apiKey", value: api_key)
                        ]
            
            if let q = queries["q"] {
                items.append( URLQueryItem(name: "q", value: q))
            }
            if let from = queries["from"] {
                items.append( URLQueryItem(name: "from", value: from))
            }
            
            items.append( URLQueryItem(name: "page", value: queries["page"]))
            
            if ((queries["q"]?.isEmpty) == nil) || ((queries["from"]?.isEmpty) == nil) {
                items.append( URLQueryItem(name: "language", value: "en"))
                items.append( URLQueryItem(name: "domains", value: "techcrunch.com,engadge.com,associated-press,usa-today,bbc.co.uk,cnn,the-washington-post,reuters,google-news"))
            }
            
            if ((queries["q"]?.isEmpty) != nil)  {
                items.removeAll(where: {$0.name == "language"})
                items.removeAll(where: {$0.name == "domains"})

            }
            return items
        case .headlines(let queries):
            var items = [
                         URLQueryItem(name: "apiKey", value: api_key)
                        ]
            
            if let q = queries["q"] {
                items.append( URLQueryItem(name: "q", value: q))
            }
            if let from = queries["from"] {
                items.append( URLQueryItem(name: "from", value: from))
            }
            if (queries["q"] == nil) {
                items.append( URLQueryItem(name: "language", value: "en"))
            }
            return items
        }
    }
    
}
