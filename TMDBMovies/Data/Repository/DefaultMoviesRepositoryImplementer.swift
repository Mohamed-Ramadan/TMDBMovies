//
//  DefaultMoviesRepositoryImplementer.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation
 
final class DefaultMoviesRepositoryImplementer: MoviesRepository {
    
    private let MoviesStorage : MoviesResponseStorage
    private let networkService: NetworkService
    
    init(MoviesStorage : MoviesResponseStorage = DefaultMoviesCoreDataStorage(), networkService: NetworkService = URLSessionNetworkService()) {
        self.MoviesStorage = MoviesStorage
        self.networkService = networkService
    }
    
    func getMovies(keyword: String, page: Int, cached: @escaping (MoviesModel) -> Void, completion: @escaping (Result<MoviesResponseDTO, Error>) -> Void) {
        let requestDTO = MoviesRequestDTO(page: page, keyword: keyword)
        
        // load Movies from cache storage
        MoviesStorage.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain(page: requestDTO.page))
            }
        }
        
        // load Movies from remote service
        networkService.getMovies(request: requestDTO, completion: completion)
    }
    
    func saveMovies(keyword: String, page: Int, MoviesDTO: MoviesResponseDTO) {
        let requestDTO = MoviesRequestDTO(page: page, keyword: keyword)
        MoviesStorage.save(responseDTO: MoviesDTO, for: requestDTO)
    }
}

