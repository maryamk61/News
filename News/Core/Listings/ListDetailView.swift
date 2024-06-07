//
//  ListDetailView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 1/30/1403 AP.
//

import SwiftUI
import MapKit
import Kingfisher

struct ListDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ExploreViewModel

    var listing: Article
    let heartColor = Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))
    var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
    }()
    
    init(listing: Article) {
        self.listing = listing
    }
    
    var body: some View {
        ScrollView {
            VStack {
                    KFImage.url(listing.imageUrl)
                        .placeholder { ProgressView() }
                        .cacheMemoryOnly()
                        .resizable()
                        .border(Color(.systemGray6), width: 0.5)
                        .frame(height: 250)
                        .padding(.top, -30)
                VStack(alignment: .leading, spacing: 20) {
                    Text(listing.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        Text(listing.author ?? "")
                            .font(.footnote).bold()
                            .foregroundStyle(.secondary)
                        Text(listing.publishedDate, formatter: dateFormatter)
                            .font(.footnote).bold()
                            .foregroundStyle(.secondary)
                            
                        Spacer()
                        Button(action:  {
                            viewModel.addOrRemove(article: listing)
                        }, label: {
                            Image(systemName: viewModel.contains(title: listing.title) ?  "bookmark.fill" : "bookmark")
                                .foregroundStyle(viewModel.contains(title: listing.title) ? heartColor : .gray)
                                .font(.title2)
                                .shadow(color: .white ,radius: 1)
                                .contentTransition(.symbolEffect(.replace))
                        })
                    }
                    .bold()
                    Text(listing.description ?? "")
                        .fontWeight(.semibold)
                    Text(listing.content ?? "")
                        .font(.subheadline)
                        .onTapGesture {
                            
                        }
                        .padding(.bottom, -10)
                    Link(destination: URL(string: listing.url)!, label: {
                        Text("more...")
                            .font(.footnote).bold()
                    })
                }
                .padding(.horizontal)
            }
            
        }
    }

}

#Preview {
    ListDetailView(listing: DeveloperPreview.mockArticles[2])
}


