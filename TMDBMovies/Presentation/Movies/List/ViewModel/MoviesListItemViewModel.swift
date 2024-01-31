//
//  MoviesListItemViewModel.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 29/01/2024.
//

import Foundation

struct MoviesListItemViewModel {
    var adult: Bool
    var backdropPath: String
    var id: Int
    var originalLanguage, originalTitle, overview: String
    var popularity: Double
    var posterPath, releaseDate, title: String
    var video: Bool
    var voteCount: Int
}

extension MoviesListItemViewModel {
    init(movie: MovieModel) {
        self.adult = movie.adult
        self.backdropPath = movie.backdropPath
        self.id = movie.id
        self.originalLanguage = movie.originalLanguage
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.popularity = movie.popularity
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate.getYear() ?? ""
        self.title = movie.title
        self.video = movie.video
        self.voteCount = movie.voteCount
    }
}
