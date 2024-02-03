//
//  NetworkService.swift
//  TMDBMovies
//
//  Created by Mohamed Ramadan on 25/01/2024.
//

import Foundation

protocol NetworkService {
    func getMovies(request: MoviesRequestDTO , completion:  @escaping (Result<MoviesResponseDTO, Error>) -> Void)
}

class URLSessionNetworkService: NetworkService {
     
    func getMovies(request: MoviesRequestDTO, completion: @escaping (Result<MoviesResponseDTO, Error>) -> Void) {
        
        let urlString = Constants.serverBaseURl + "3/discover/movie?page=\(request.page)&with_keywords=\(request.keyword)"
        guard let urlEncodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: urlEncodedString) else {
            print("Wrong URL!: \(urlString)")
            return
        }
        
        

        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.allHTTPHeaderFields = Constants.apiHeaders
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "Data not valid or empty", code: 402, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                // parse json data to model items
                let response = try JSONDecoder().decode(MoviesResponseDTO.self, from: data)
                
                completion(.success(response))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
