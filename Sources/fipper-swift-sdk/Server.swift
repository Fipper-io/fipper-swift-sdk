//
//  Server.swift
//  
//
//  Created by Alexander Perechnev on 25.01.2022.
//

import Foundation

class Server {
    
    private let host = "https://sync2.fipper.io"
    
    // MARK: Destinations
    
    func hashRequest(eTag: String, apiToken: String, projectId: Int) -> URLRequest {
        let queryItems = [
            URLQueryItem(name: "apiToken", value: apiToken),
            URLQueryItem(name: "item", value: "\(projectId)"),
            URLQueryItem(name: "eTag", value: eTag)
        ]
        return self.request(path: "/hash", method: "HEAD", queryItems: queryItems)
    }
    
    func configRequest(apiToken: String, projectId: Int) -> URLRequest {
        let queryItems = [
            URLQueryItem(name: "apiToken", value: apiToken),
            URLQueryItem(name: "item", value: "\(projectId)"),
        ]
        return self.request(path: "/config", method: "GET", queryItems: queryItems)
    }
    
    // MARK: Helpers
    
    private func request(path: String, method: String, queryItems: [URLQueryItem]) -> URLRequest {
        guard var components = URLComponents(string: self.host) else {
            fatalError("Can't parse host: \(self.host)")
        }
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("Can't create URL from components: \(components)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }
    
}
