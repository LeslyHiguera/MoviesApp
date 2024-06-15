//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by Lesly Higuera on 12/06/24.
//

import XCTest
@testable import MoviesApp

final class MainViewModelTests: XCTestCase {
    
    let moviesResponse = [MovieResponse(id: 0, genreIds: [1], title: "title", originalTitle: "originalTitle", adult: false, originalLanguage: "originalLanguage", voteAverage: 5.0, overview: "overview", imageUrl: "imageUrl", releaseDate: "releaseDate")]
    
    var viewModel: MainViewModel!
    var mockManager: MockMainManager!

    override func setUpWithError() throws {
        mockManager = MockMainManager()
        viewModel = MainViewModel(manager: mockManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockManager = nil
    }

    func testGetMoviesSuccess() {
        let expectation = self.expectation(description: "Movies fetched successfully")
        
        viewModel.getMovies()
        
        viewModel.outputEvents.observe { event in
            switch event {
            case .didGetData:
                XCTAssertEqual(self.viewModel.movies.count, 1)
                expectation.fulfill()
            default:
                break
            }
        }
            
        waitForExpectations(timeout: 2.0, handler: nil)
    }
        
    func testGetMoviesFailure() {
        mockManager.shouldReturnError = true
        
        let expectation = self.expectation(description: "Failed to fetch movies")
        
        viewModel.getMovies()
        
        viewModel.outputEvents.observe { event in
            switch event {
            case .errorMessage(let error):
                XCTAssertEqual(error, "Error fetching movies")
                expectation.fulfill()
            default:
                break
            }
        }
            
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSearchMoviesSuccess() {
        let expectation = self.expectation(description: "Movies fetched successfully")
        
        viewModel.getMovies(isSearching: true, query: "title")
        
        viewModel.outputEvents.observe { event in
            switch event {
            case .didGetData:
                XCTAssertEqual(self.viewModel.movies.count, 1)
                expectation.fulfill()
            default:
                break
            }
        }
            
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSearchMoviesFailure() {
        mockManager.shouldReturnError = true
        
        let expectation = self.expectation(description: "Failed to fetch movies")
        
        viewModel.getMovies(isSearching: true, query: "Nonexistent")
        
        viewModel.outputEvents.observe { event in
            switch event {
            case .errorMessage(let error):
                XCTAssertEqual(error, "Error fetching movies")
                expectation.fulfill()
            default:
                break
            }
        }
            
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testTextFieldDidChangeSelectionEmptyText() {
        let expectation = self.expectation(description: "Empty text handling")
        
        viewModel.textFieldDidChangeSelection(text: "")
        
        viewModel.outputEvents.observe { event in
            switch event {
            case .emptySearch(let isEmpty):
                XCTAssertTrue(isEmpty)
                expectation.fulfill()
            default:
                break
            }
        }
        
        waitForExpectations(timeout: 1.5, handler: nil)
    }
        
    func testTextFieldDidChangeSelectionWithResults() {
        viewModel.movies = moviesResponse
        
        let expectation = self.expectation(description: "Search results found")
        
        viewModel.textFieldDidChangeSelection(text: "title")
        
        viewModel.outputEvents.observe { event in
            switch event {
            case .didGetData:
                XCTAssertFalse(self.viewModel.isFiltering)
                XCTAssertEqual(self.viewModel.movies.count, 1)
                XCTAssertEqual(self.viewModel.movies.first?.title, "title")
                expectation.fulfill()
            default:
                break
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
        
    func testTextFieldDidChangeSelectionNoResults() {
        viewModel.movies = moviesResponse
            
        let expectation = self.expectation(description: "Empty search results")
            
        viewModel.textFieldDidChangeSelection(text: "Nonexistent")
        
        viewModel.outputEvents.observe { event in
            switch event {
            case .emptySearchResults(let isEmpty):
                XCTAssertTrue(isEmpty)
                expectation.fulfill()
            default:
                break
            }
        }
            
        waitForExpectations(timeout: 1.5, handler: nil)
    }

}
