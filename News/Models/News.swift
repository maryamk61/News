//
//  Listing.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/3/1403 AP.
//

import Foundation


struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable, Hashable {
   
//    var id : String = UUID().uuidString
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    var imageUrl: URL? {
        guard (urlToImage != nil) else {
            return nil
        }
        return URL(string: urlToImage!)
    }
    
    var publishedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        return dateFormatter.date(from: publishedAt) ?? Date()
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = (try? values.decode(String.self, forKey: .id)) ?? UUID().uuidString
//        title = try values.decode(String.self, forKey: . title)
//        source = try values.decode(Source.self, forKey: . source)
//        author = try? values.decode(String.self, forKey: .author)
//        description = try? values.decode(String.self, forKey: . description)
//         url = try values.decode(String.self, forKey: . url)
//        urlToImage = try? values.decode(String.self, forKey: . urlToImage) 
//        publishedAt = try values.decode(String.self, forKey: . publishedAt)
//        content = try? values.decode(String.self, forKey: . content)
//        }
    
//    enum CodingKeys: CodingKey {
//        case source
//        case author
//        case title
//        case description
//        case url
//        case urlToImage
//        case publishedAt
//        case content
//    }
    
    
}

struct Source: Codable, Hashable {
    let name: String?
    var id: String = UUID().uuidString
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? values.decode(String.self, forKey: .id)) ?? UUID().uuidString
        name = try? values.decode(String.self, forKey: . name) 
        }
}

