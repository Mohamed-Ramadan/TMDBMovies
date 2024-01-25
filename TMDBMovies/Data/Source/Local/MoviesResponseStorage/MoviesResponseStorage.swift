//
//  MoviesResponseStorage.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

protocol MoviesResponseStorage {
   func getResponse(for requestDTO: MoviesRequestDTO, completion: @escaping (Result<MoviesResponseDTO?, CoreDataStorageError>) -> Void)
   func save(responseDTO: MoviesResponseDTO, for requestDTO: MoviesRequestDTO)
}
