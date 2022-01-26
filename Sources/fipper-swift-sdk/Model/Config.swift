//
//  Config.swift
//  
//
//  Created by Alexander Perechnev on 25.01.2022.
//

import Foundation
import Gzip

struct ConfigResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case config = "config"
        case eTag = "eTag"
    }
    
    let config: [String:[String:FlagType]]
    let eTag: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.eTag = try values.decode(String.self, forKey: .eTag)
        
        let configurations = try values.decode([String:String].self, forKey: .config)
        
        self.config = try configurations.mapValues { value -> [String:FlagType] in
            let decodedData = Data(base64Encoded: value)!
            let decompressedData = try decodedData.gunzipped()
            
            let dictionary = try JSONSerialization.jsonObject(
                with: decompressedData, options: []
            ) as! [String:AnyObject]
            
            return dictionary.mapValues { value -> FlagType in
                let d = value as! [String:AnyObject]
                return FlagType(dictionary: d)
            }
        }
    }
    
}
