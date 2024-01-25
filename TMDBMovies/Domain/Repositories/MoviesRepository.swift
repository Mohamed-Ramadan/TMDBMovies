//
//  MoviesRepository.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

protocol MoviesRepository {
     
    func getMovies(limit: Int, page: Int,
                   cached: @escaping (MoviesModel) -> Void,
                   completion: @escaping (Result<MoviesResponseDTO, Error>) -> Void)
    
    func saveMovies(limit: Int, page: Int,
                    MoviesDTO: MoviesResponseDTO)
}

