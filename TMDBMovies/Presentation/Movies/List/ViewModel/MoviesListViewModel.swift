//
//  MoviesListViewModel.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 29/01/2024.
//

import Foundation

enum MoviesListViewModelLoading {
   case fullScreen
   case nextPage
   case none
}

protocol MoviesListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSelectItem(at indexPath: IndexPath) -> MovieModel
}


class MoviesListViewModel: MoviesListViewModelInput {
    
    private(set) var MoviesUseCase: MoviesUseCase
    var pages: [MoviesModel] = [] {
        didSet{
            self.moviesCompletionHandler()
        }
    }
    
    private(set) var totalMovies = 1
    private(set) var pageSize = 10
    private(set) var currentPage = 0
    var nextPage: Int { currentPage + 1 }
     
    private(set) var loading: MoviesListViewModelLoading = .none {
        didSet {
            self.loadingCompletionHandler(loading)
        }
    }
     
    var error:(_ errMsg: String)->() = {_ in}
    var moviesCompletionHandler: ()->() = {}
    var loadingCompletionHandler:(_ loading: MoviesListViewModelLoading) -> () = {_ in}
    
    //MARK: - init
    init(MoviesUseCase: MoviesUseCase) {
        self.MoviesUseCase = MoviesUseCase
    }
    
    //MARK:- Private
    private func appendPage(_ page: MoviesModel) {
        loading = .none
        currentPage = page.page
        
        pages = pages
            .filter { $0.page != page.page }
            + [page]
    }
     
    private func load(loading: MoviesListViewModelLoading) {
        
        self.loading = loading
        let request = MoviesRequestValue(page: nextPage, limit: pageSize)
        
        MoviesUseCase.fetchMovies(requestValue: request, cached: appendPage) { (result) in
            self.loading = .none
            
            switch result {
            case .success(let MoviesPage):
                self.appendPage(MoviesPage)
            case .failure(let error):
                self.error(error.localizedDescription)
            }
        }
    }
   
    private func resetPages() {
        currentPage = 0
        totalMovies = 1
        pages.removeAll()
    }
    
    func update() {
        resetPages()
        
        load(loading: .fullScreen)
    }
    
    func getViewModel(for indexPath: IndexPath) -> MoviesListItemViewModel {
        return MoviesListItemViewModel.init(movie: self.pages.moviesSections[indexPath.section][indexPath.row])
    }
}


// MARK: - INPUT. View event methods
extension MoviesListViewModel {
    func viewDidLoad() {}
     
    func didSelectItem(at indexPath: IndexPath) -> MovieModel {
        return pages.moviesSections[indexPath.section][indexPath.row]
    }
    
    func didLoadNextPage() {
        guard self.loading == .none else {
            return
        }
        
        load(loading: .nextPage)
    }
}

// MARK: - Private

extension Array where Element == MoviesModel {
    var movies: [MovieModel] { flatMap { $0.movies } }
    var moviesSections: [[MovieModel]] {movies.chunked(into: 5)}
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
