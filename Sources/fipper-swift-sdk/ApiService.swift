//
//  ApiService.swift
//  
//
//  Created by Alexander Perechnev on 25.01.2022.
//

import Foundation

class ApiService {
    
    private let server = Server()
    private let token: String
    
    // MARK: Initialization
    
    init(token: String) {
        self.token = token
    }
    
    // MARK: Requests
    
    func fetchHash(projectId: Int, eTag: String) -> Int? {
        let request = self.server.hashRequest(
            eTag: eTag,
            apiToken: self.token,
            projectId: projectId
        )
        let (_, response, _) = self.makeSync(request: request)
        return (response as? HTTPURLResponse)?.statusCode
    }
    
    func fetchConfig(projectId: Int) throws -> (Data?, Error?) {
        let request = self.server.configRequest(
            apiToken: self.token, projectId: projectId
        )
        let result = self.makeSync(request: request)
        
        let statusCode = (result.1 as? HTTPURLResponse)?.statusCode
        guard statusCode == 200 else {
            throw FipperError.configNotFound
        }
        
        return (result.0, result.2)
    }
    
    private func makeSync(request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var result: (Data?, URLResponse?, Error?)
        
        let semaphore = DispatchSemaphore(value: .zero)
        
        let handler = { (data: Data?, response: URLResponse?, error: Error?) in
            result = (data, response, error)
            semaphore.signal()
        }
        URLSession.shared.dataTask(with: request, completionHandler: handler).resume()
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
    }
    
}
