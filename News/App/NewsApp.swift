//
//  AirbnbApp.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 1/27/1403 AP.
//

import SwiftUI

@main
struct NewsApp: App {
    
    @StateObject var exploreViewModel = ExploreViewModel(service: NewsService(), bookmarkManager: BookmarkManager())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(exploreViewModel)
        }
    }
}
