//
//  Rate.swift
//  
//
//  Created by Alexander Perechnev on 25.01.2022.
//

import Foundation

public enum Rate: Int {
    
    case frequently = 3
    case normal = 7
    case rarely = 15
    
    var timeInterval: TimeInterval {
        TimeInterval(self.rawValue)
    }
    
}
