//
//  Error.swift
//  
//
//  Created by Alexander Perechnev on 26.01.2022.
//

import Foundation

enum FipperError: Error {
    case configNotFound
    case emptyDataResponse
    case invalidJson
}
