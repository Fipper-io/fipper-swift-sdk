//
//  Fipper.swift
//
//
//  Created by Alexander Perechnev on 25.01.2022.
//

import Foundation

public class Fipper {
    
    // MARK: Configuration
    
    private let apiService: ApiService
    private let rate: Rate
    private let environment: String
    private let projectId: Int
    
    // MARK: Sync variables
    
    private var config: [String:FlagType]?
    private var eTag: String?
    private var previousSyncDate: Date?
    
    // MARK: Initialization
    
    public init(rate: Rate, environment: String, apiToken: String, projectId: Int) {
        self.apiService = ApiService(token: apiToken)
        self.rate = rate
        self.environment = environment
        self.projectId = projectId
    }
    
    // MARK: Public interface
    
    public func getConfig(
        completion: @escaping ([String:FlagType]?, Error?) -> Void
    ) {
        DispatchQueue.global(qos: .utility).async {
            do {
                try self.retrieveConfig(completion: completion)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    // MARK: Library logic
    
    private var cachedConfig: [String:FlagType]? {
        guard let syncDate = self.previousSyncDate else {
            return nil
        }
        guard syncDate.timeIntervalSinceNow <= self.rate.timeInterval else {
            return nil
        }
        return self.config
    }
    
    private func retrieveConfig(
        completion: @escaping ([String:FlagType]?, Error?) -> Void
    ) throws {
        if let config = self.cachedConfig {
            completion(config, nil)
            return
        }
        
        if let _ = self.previousSyncDate, let _ = self.config, let eTag = self.eTag {
            let code = self.apiService.fetchHash(projectId: self.projectId, eTag: eTag)
            if code == 304 {
                completion(self.config, nil)
                return
            }
        }
        
        let result = try self.apiService.fetchConfig(projectId: self.projectId)
        guard let data = result.0 else {
            throw FipperError.emptyDataResponse
        }
        
        let response: ConfigResponse
        do {
            response = try JSONDecoder().decode(ConfigResponse.self, from: data)
        } catch {
            throw FipperError.invalidJson
        }
        
        self.config = response.config[self.environment]
        self.eTag = response.eTag
        self.previousSyncDate = Date()
        
        completion(self.config, result.1)
    }
    
}
