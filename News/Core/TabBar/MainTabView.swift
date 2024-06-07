//
//  TabView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/3/1403 AP.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
//                .environmentObject(viewModel)
            ‌BookmarkView()
                .tabItem {
                    Label("Bookmarks", systemImage: "bookmark")
                }
//                .environmentObject(viewModel)
        }
        
        
    }
}

#Preview {
    MainTabView()
}
