//
//  DataService.swift
//  iOsNetworking
//
//  Created by Miguel Rueda on 01/07/20.
//  Copyright © 2020 Miguel Rueda. All rights reserved.
//

import Foundation

class DataService {
    
    static let shared = DataService()
    fileprivate let baseUrlString = "https://api.github.com"
    
    // Allow to execute after method returns
    func fetchGists(completion: @escaping (Result<Any, Error>) -> Void) {
//        var baseURL = URL(string: baseUrlString)
//        baseURL?.appendPathComponent("/somePath")
//
//        let composedURL = URL(string: "/somePath", relativeTo: baseURL)
//        print(baseURL!)
//        print(composedURL?.absoluteString ?? "Relative URL failed...")
        
        var componentURL = URLComponents()
        componentURL.scheme = "https"
        componentURL.host = "api.github.com"
        componentURL.path = "/gists/public"
        
        guard let validURL = componentURL.url else {
            print("URL Creation failed")
            return
        }
        
        URLSession.shared.dataTask(with: validURL) {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("API status: \(httpResponse.statusCode)")
            }
            
            guard let validData = data,  error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: [])
                completion(.success(json))
            } catch let serializationError{
                completion(.failure(serializationError))
            }
        }.resume()
    }
    
    
}
