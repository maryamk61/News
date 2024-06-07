//
//  WishlistView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/3/1403 AP.
//

import SwiftUI

struct ‌BookmarkView: View {
    @EnvironmentObject var viewModel: ExploreViewModel
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.favorites, id: \.self) { item in
                        NavigationLink {
                            ListDetailView(listing: item)
                        } label: {
                            ListingItemView(listing: item)
                                .frame(height: 360)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Divider()
                    }
                }
                .padding(.vertical,8)
                .padding(.horizontal, 12)
            }
            .navigationTitle("‌Bookmarks")
            .onAppear {
                viewModel.getFavorites()
            }
        }
    }
}

#Preview {
    
    ‌BookmarkView()
        .environmentObject(ExploreViewModel(service: NewsService(), bookmarkManager: BookmarkManager()))
    
}
