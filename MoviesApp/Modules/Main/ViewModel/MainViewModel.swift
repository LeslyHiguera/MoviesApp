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
}

class MainViewModel {
    
    var page = 1
    
    var movies: [MovieResponse] = []
    
    private var manager: MainManager
    
    var outputEvents: Observable<MainViewModelOutput> {
        mutableOutputEvents
    }
    
    private let mutableOutputEvents = MutableObservable<MainViewModelOutput>()
    
    init(manager: MainManager) {
        self.manager = manager
    }
    
    func getPopularMovies() {
        mutableOutputEvents.postValue(.isLoading(true))
        manager.getPopularMovies(page: page) { [weak self] result in
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
}
