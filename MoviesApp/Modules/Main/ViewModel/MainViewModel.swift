//
//  MainViewModel.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 13/06/24.
//

import Foundation

enum MainViewModelOutput {
    case isLoading(Bool)
    case didGetData
    case errorMessage(String)
    case emptySearch(Bool)
    case emptySearchResults(Bool)
}

enum MoviesCategory {
    case popular
    case topRated
}

class MainViewModel {
    
    // MARK: - Properties
    
    var page = 1
    var category: MoviesCategory = .popular
    var isFiltering = false
    var isSearching = false
    var movies: [MovieResponse] = []
    var moviesSearch: [MovieResponse] = []
    
    private var manager: MainManager
    
    // MARK: - Observable properties
    
    var outputEvents: Observable<MainViewModelOutput> {
        mutableOutputEvents
    }
    
    private let mutableOutputEvents = MutableObservable<MainViewModelOutput>()
    
    // MARK: - Initializers
    
    init(manager: MainManager) {
        self.manager = manager
    }
    
    // MARK: - Methods
    
    func getMovies(isSearching: Bool = false, query: String = "") {
        if isSearching {
            self.isSearching = true
            movies = []
            page = 1
        }
        mutableOutputEvents.postValue(.isLoading(true))
        manager.getMovies(url: getURL(isSearching: isSearching, category: category, page: page, query: query), page: page, isSearching: isSearching, query: query) { [weak self] result in
            self?.mutableOutputEvents.postValue(.isLoading(false))
            switch result {
            case .success(let movies):
                movies.results?.forEach { (movie) in
                    if self?.movies.contains(where: {$0.id != movie.id}) != nil {
                        self?.movies.append(movie)
                    }
                }
                self?.mutableOutputEvents.postValue(.didGetData)
            case .failure(let error):
                self?.mutableOutputEvents.postValue(.errorMessage(error.localizedDescription))
            }
        }
    }
    
    func textFieldDidChangeSelection(text: String?) {
        guard let text = text else { return }
        getMovies(isSearching: true, query: text)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] _ in
            
            if text.isEmpty {
                mutableOutputEvents.postValue(.emptySearch(true))
                return
            }
            
            for movie in movies {
                if let title = movie.title {
                    if title.lowercased().contains(text.lowercased()) {
                        moviesSearch.append(movie)
                    }
                }
            }
            
            if moviesSearch.count > 0 {
                isFiltering = true
                movies = []
                movies = moviesSearch
                moviesSearch = []
                mutableOutputEvents.postValue(.didGetData)
            } else {
                mutableOutputEvents.postValue(.emptySearchResults(true))
            }
        }
    }
    
    private func getURL(isSearching: Bool, category: MoviesCategory, page: Int, query: String) -> String {
        if isSearching {
            return APIRouter(page: page, query: query).searchUrl
        } else {
            return category == .popular ? APIRouter(page: page).popularUrl : APIRouter(page: page).topRatedUrl
        }
    }
 
}
