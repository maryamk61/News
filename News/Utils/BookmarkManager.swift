//
//  BookmarksViewModel.swift
//  News
//
//  Created by Maryam Kaveh on 2/21/1403 AP.
//

import Foundation

class BookmarkManager: ObservableObject {
    var titles: Set<String>
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "bookmarks") {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
               titles = decoded
                return
            }
        }
        titles = []
    }
    
    func addOrRemove(title: String) {
        objectWillChange.send()
        if !contains(title: title) {
            titles.insert(title)
        } else {
            titles.remove(title)
        }
        if let encoded = try? JSONEncoder().encode(titles) {
            UserDefaults.standard.set(encoded, forKey: "bookmarks")
        }
    }
    
    func contains(title: String)  -> Bool {
        return titles.contains(where: {$0 == title})
    }
   
}
