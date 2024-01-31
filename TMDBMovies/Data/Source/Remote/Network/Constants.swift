//
//  Constants.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

class Constants {
    static let serverBaseURl = "https://api.themoviedb.org/"
    
    static let apiHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YTY0ODA3NzY4YzAxN2Q2MGFmMDc3ODBlMzlkNGFkZCIsInN1YiI6IjY1YjJkZTlmZDU1YzNkMDE3YzQwY2RlOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.EtNXAzuTI2WtLieO8jjkvZCr2-oJMZQ2ahEYnOMZ6hk"
      ]
}

enum HTTPMethod: String {
    case get = "GET"
}

