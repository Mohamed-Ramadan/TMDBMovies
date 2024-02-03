//
//  MoviesRepository.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

protocol MoviesRepository {
     
    func getMovies(keyword: String, page: Int,
                   cached: @escaping (MoviesModel) -> Void,
                   completion: @escaping (Result<MoviesResponseDTO, Error>) -> Void)
    
    func saveMovies(keyword: String, page: Int,
                    MoviesDTO: MoviesResponseDTO)
}

