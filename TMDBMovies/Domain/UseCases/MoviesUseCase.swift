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
    
   private let MoviesRepository: MoviesRepository
   
   init(MoviesRepository: MoviesRepository) {
       self.MoviesRepository = MoviesRepository
   }
   
   func fetchMovies(requestValue: MoviesRequestValue, cached: @escaping (MoviesModel) -> Void, completion: @escaping (Result<MoviesModel, Error>) -> Void) {
       
       return self.MoviesRepository.getMovies(limit: requestValue.limit, page: requestValue.page,
                                              cached: cached) { (result) in
           
           switch result {
               case .success(let model):
                   
                   // only cache first 20 Movies
                   if (requestValue.page * requestValue.limit) <= 20 {
                       self.MoviesRepository.saveMovies(limit: requestValue.limit, page: requestValue.page,
                                                        MoviesDTO: model)
                   }
                   
                   completion(.success(model.toDomain(page: requestValue.page)))
                   
               case .failure(let error):
                   completion(.failure(error))
           }
        }
   }
}

struct MoviesRequestValue {
   let page: Int
   let limit: Int
}
