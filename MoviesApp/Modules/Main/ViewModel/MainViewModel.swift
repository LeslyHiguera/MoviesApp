//
//  MainViewModel.swift
//  MoviesApp
//
//  Created by Admin on 13/06/24.
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
    
    var page = 1
    var category: MoviesCategory = .popular
    var isFiltering = false
    var movies: [MovieResponse] = []
    var moviesSearch: [MovieResponse] = []
    
    private var manager: MainManager
    
    var outputEvents: Observable<MainViewModelOutput> {
        mutableOutputEvents
    }
    
    private let mutableOutputEvents = MutableObservable<MainViewModelOutput>()
    
    init(manager: MainManager) {
        self.manager = manager
    }
    
    func getMovies() {
        mutableOutputEvents.postValue(.isLoading(true))
        manager.getMovies(page: page, category: category) { [weak self] result in
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
}
