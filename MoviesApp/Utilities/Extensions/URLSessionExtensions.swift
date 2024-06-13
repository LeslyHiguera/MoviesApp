//
//  URLSessionExtensions.swift
//  MoviesApp
//
//  Created by Admin on 13/06/24.
//

import Foundation

extension URLSession {
    
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    func request<T: Codable>(url: URL?, expecting: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void ) {
        guard let url = url else {
            DispatchQueue.main.async {
                completionHandler(.failure(CustomError.invalidData))
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(CustomError.invalidData))
                    }
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(result))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
        
    }
    
}
