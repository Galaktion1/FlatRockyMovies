//
//  FetchMovie.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 29.07.22.
//

import Foundation


class MovieStore: MovieService {
    
    static let shared = MovieStore()
    private init() {}
    
    private let apiKey = "07b3c5721acb723e40379334a99591ef"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    
    let parameter = ["api_key": "07b3c5721acb723e40379334a99591ef"]
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        
        var urlComponents = URLComponents(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)")

        var queryItems = [URLQueryItem]()
        for (key, value) in parameter {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                print(response!)
                return
            }
            
            if let error = error {
                completion(.failure(.serializationError))
                print("\(error)")
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }
            catch  {
                print(error)
                completion(.failure(.apiError))
            }

        }.resume()
    }
    
}
