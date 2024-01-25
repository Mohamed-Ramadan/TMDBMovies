//
//  MoviesModel.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

struct MoviesModel {
    let page: Int
    let movies: [MovieModel]
}

// MARK: - MovieModel
struct MovieModel {
    let id, author: String
    let url, downloadURL: String
}
   
