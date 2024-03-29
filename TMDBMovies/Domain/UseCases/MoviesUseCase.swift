//
//  MoviesUseCase.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation
 
protocol MoviesUseCase {
   func fetchMovies(requestValue: MoviesRequestValue,
                    cached: @escaping (MoviesModel) -> Void,
                    completion: @escaping (Result<MoviesModel, Error>) -> Void)
}

final class DefaultMoviesUseCase: MoviesUseCase {
    
   private let moviesRepository: MoviesRepository
   
   init(MoviesRepository: MoviesRepository) {
       self.moviesRepository = MoviesRepository
   }
   
   func fetchMovies(requestValue: MoviesRequestValue, cached: @escaping (MoviesModel) -> Void, completion: @escaping (Result<MoviesModel, Error>) -> Void) {
       
       return self.moviesRepository.getMovies(keyword: requestValue.keyword, page: requestValue.page,
                                              cached: cached) { (result) in
           
           switch result {
               case .success(let model):
                   
               self.moviesRepository.saveMovies(keyword: requestValue.keyword, page: requestValue.page,
                                                MoviesDTO: model)
                   
                   completion(.success(model.toDomain(page: requestValue.page)))
                   
               case .failure(let error):
                   completion(.failure(error))
           }
        }
   }
}

struct MoviesRequestValue {
   let page: Int
   let keyword: String
}
