//
//  ExploreViewModel.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/3/1403 AP.
//

import Foundation
import Combine

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var filteredListings: [Article] = []
    @Published var searchedListings: [Article] = []
    @Published var search: String = ""
    @Published var fromDate: String = ""
    @Published var loggedIn: Bool = true
    @Published var isLoading: Bool = true
    @Published var isBookmarked: Bool = false
    @Published var favorites: [Article] = []
    @Published var eventError: ApiError?
    @Published var hasMoreRows: Bool = false
    @Published var showEmptyData: Bool = false
    
    //pagination data
    var totalItemsAvailable: Int = 0
    var itemsLoadedCount: Int = 0
    private var totalSearchItemsAvailable: Int = 0
    private var itemsSearchLoadedCount: Int = 0
    @Published var page: Int = 1
    @Published var searchPage: Int = 1
    var pageSize: Int = 100
    
    var allListings: [Article] = []
    let service: NewsService
    var cancellables = Set<AnyCancellable>()
    var bookmarksManager: BookmarkManager
    
    init(service: NewsService = NewsService(), bookmarkManager: BookmarkManager) {
        self.service = service
        self.bookmarksManager = bookmarkManager
        addSubscriber()
        combineFetch()
    }
    
    func getFavorites(){
        self.favorites = filteredListings.filter({bookmarksManager.contains(title: $0.title ?? "")})
    }
    
    func addOrRemove(article: Article){
        bookmarksManager.addOrRemove(title: article.title ?? "")
        self.getFavorites()
    }
    
    func contains(title: String) -> Bool {
        return bookmarksManager.contains(title: title)
    }
    
    func addSubscriber() {
        $search
            .combineLatest($fromDate)
            .debounce(for: .seconds(0.7), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (search, fromDate) in
                self?.page = 1
                if search.isEmpty && fromDate.isEmpty{
                    self?.itemsLoadedCount = 0
                    self?.itemsLoadedCount = 0
                    self?.filteredListings = self?.allListings ?? []
                } else {
                    self?.searchArticles()
                }
                
//                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    // Async way
//    func asyncFetch() {
//        var queries = [String: String]()
//        if !fromDate.isEmpty {
//            queries.updateValue(fromDate, forKey: "from")
//        }
//        if !search.isEmpty {
//            queries.updateValue(search, forKey: "q")
//        }
//        Task {
//            filteredListings = try await service.asyncFetch(endpoint: NewsEndpoints.headlines(queries: queries), responseModel: NewsResponse.self).articles
//        }
//    }
    //Combine way
    func combineFetch() {
        var queries = [String: String]()
        if !fromDate.isEmpty {
            queries.updateValue(fromDate, forKey: "from")
        }
        
        if self.itemsLoadedCount < self.totalItemsAvailable {
            self.page += 1
        }
       
        queries.updateValue(String(self.page), forKey: "page")
        
//        service.combineFetch(completion: { [weak self] result in
//            //print(result)
//            switch result {
//            case .success(let results):
//                self?.allListings.append(contentsOf: results.articles)
//                self?.filteredListings.append(contentsOf: results.articles)
//                
//            case .failure(let error):
//                print(error)
//            }
//            
//        })
        service.combineFetch(endpoint: NewsEndpoints.everything(queries: queries) , responseModel: NewsResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] response in
                if response.totalResults == 0 {
                    self?.showEmptyData = true
                    self?.page = 1
                }
                self?.allListings.append(contentsOf: response.articles)
                self?.totalItemsAvailable = response.totalResults
                self?.filteredListings.append(contentsOf: response.articles)
                self?.itemsLoadedCount = self?.filteredListings.count ?? 0
//                self?.isLoading = false
            }
            .store(in: &cancellables)

    }
    
    func searchArticles() {
        self.filteredListings = []
        var queries = [String: String]()
        if !fromDate.isEmpty {
            queries.updateValue(fromDate, forKey: "from")
        }
        if !search.isEmpty {
            queries.updateValue(search, forKey: "q")
        }
       
        queries.updateValue(String(self.searchPage), forKey: "page")
        
        service.combineFetch(endpoint: NewsEndpoints.everything(queries: queries) , responseModel: NewsResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] response in
                if response.totalResults == 0 {
                    self?.showEmptyData = true
                }
                
//                self?.totalSearchItemsAvailable = response.totalResults
                self?.filteredListings.append(contentsOf: response.articles)
//                self?.itemsSearchLoadedCount = self?.filteredListings.count ?? 0
//                self?.isLoading = false
            }
            .store(in: &cancellables)

    }
}
