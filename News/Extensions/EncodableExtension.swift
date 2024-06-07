//
//  EncodableExtension.swift
//  News
//
//  Created by Maryam Kaveh on 2/24/1403 AP.
//

import Foundation

extension Encodable {

    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
