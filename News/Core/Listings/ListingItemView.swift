//
//  ListingView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 1/27/1403 AP.
//

import SwiftUI
import Kingfisher

struct ListingItemView: View {
    var listing: Article
    
    var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
    }()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            KFImage.url(listing.imageUrl)
                .placeholder { ProgressView() }
                .cacheMemoryOnly()
                .resizable()
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .border(Color(.systemGray6), width: 0.5)
            Text(listing.title ?? "")
                .font(.headline)
                .bold()
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                Text(listing.source.name ?? "")
                    .font(.footnote).bold()
                    .foregroundStyle(.secondary)
                Text(listing.publishedDate, formatter: dateFormatter)
                    .font(.footnote).bold()
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
        .foregroundStyle(Color.primary)
        
    }
}

#Preview {
    ListingItemView(listing: (DeveloperPreview.mockResponse.articles[2]))
}
