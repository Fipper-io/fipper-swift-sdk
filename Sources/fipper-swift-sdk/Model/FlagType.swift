//
//  FlagType.swift
//  
//
//  Created by Alexander Perechnev on 26.01.2022.
//

import Foundation

public enum FlagType {
    
    case boolean(state: Bool, value: Bool)
    case integer(state: Bool, value: Int)
    case string(state: Bool, value: String)
    case json(state: Bool, value: [String:AnyObject])
    
    public init(dictionary: [String:AnyObject]) {
        let state = dictionary["state"] as! Bool
        let type = dictionary["type"] as! Int
        
        switch type {
        case 10:
            self = .boolean(state: state, value: dictionary["value"] as! Bool)
        case 20:
            self = .integer(state: state, value: dictionary["value"] as! Int)
        case 30:
            self = .string(state: state, value: dictionary["value"] as! String)
        case 40:
            let data = (dictionary["value"] as! String).data(using: .utf8)!
            let value = try! JSONSerialization.jsonObject(
                with: data, options: []
            ) as! [String:AnyObject]
            self = .json(state: state, value: value)
        default:
            fatalError("Unknown flag type: \(type)")
        }
    }
    
}
