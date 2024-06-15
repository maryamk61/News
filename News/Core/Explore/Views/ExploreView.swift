//
//  ExploreView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 1/27/1403 AP.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var viewModel: ExploreViewModel
    @State var showDatePicker: Bool = false
    @State private var date: Date = Date.now
    @State private var showMore: Bool = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
//                if viewModel.isLoading {
//                    ProgressView()
//                        .padding(.trailing, 100)
//                }
                ScrollView {
                    HStack {
                        SearchBar(search: $viewModel.search)
                            .padding(.bottom, 15)
                            .padding(.top, 15)
                            .padding(.leading)
                        
                        DatePicker(selection: $date,in: ...Date.now, displayedComponents: .date) {
                            Text("")
                        }
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .padding(.trailing)
                        .onChange(of: date, { oldValue, newValue in
                            viewModel.fromDate = dateFormatter.string(from: newValue)
                        })
                    }
                 //   ZStack {
                        
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.filteredListings, id:\.self) { item in
                                NavigationLink {
                                    ListDetailView(listing: item)
                                } label: {
                                    if item.title != "[REMOVED]" {
                                        ListingItemView(listing: item)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .foregroundStyle(.primary)
                                            .padding(5)
                                            .onAppear {
                                                if item == viewModel.filteredListings.last && viewModel.itemsLoadedCount != viewModel.totalItemsAvailable {
                                                    
                                                    showMore = true
                                                    if viewModel.search.isEmpty && viewModel.fromDate.isEmpty {
                                                        viewModel.combineFetch()
                                                    }
                                                } else {
                                                    showMore = false
                                                }
                                            }
                                        Divider()
                                    }
                                        
                                }
                            }
                            HStack(spacing: 15) {
                                Text("Loading more news...")
                                    .foregroundStyle(.secondary)
                                    .font(.callout)
                                    .padding(.vertical, 30)
                                ProgressView()
                            }
                            .opacity(showMore ? 1.0 : 0.0)
                            
                        }
                        .padding(.vertical,8)
                        .padding(.horizontal, 12)
                        .navigationTitle("News")
                        .overlay {
                            emptyView
                        }
            }
                .refreshable {
                    viewModel.page = 1
                    viewModel.combineFetch()
                }
            }
        }
    }
}

extension ExploreView {
    var emptyView: some View {
        VStack(spacing: 15) {
            
            Text("Nothing Found!")
                .font(.title).bold()
                .foregroundStyle(Color(.systemGray))
            Text("No news, good news ;)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 200)
        .opacity(viewModel.showEmptyData ? 1.0 : 0.0)
    }
}

#Preview {
    ExploreView()
        .environmentObject(ExploreViewModel(service: NewsService(), bookmarkManager: BookmarkManager()))
}
