//
//  ApiError.swift
//  News
//
//  Created by Maryam Kaveh on 2/24/1403 AP.
//

import Foundation

struct ApiError: Error {
//    var statusCode: Int
    var message: String
    var errorCode: String
    
    init(message: String, errorCode: String) {
//        self.statusCode = statusCode
        self.message = message
        self.errorCode = errorCode
    }
    

//    private enum CodingKeys: String, CodingKey {
//            case errorCode
//            case message
//        }
}
