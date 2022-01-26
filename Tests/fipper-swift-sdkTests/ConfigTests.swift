//
//  ConfigTests.swift
//  
//
//  Created by Alexander Perechnev on 26.01.2022.
//

import XCTest
@testable import fipper_swift_sdk

final class ConfigTests: XCTestCase {
    
    private let payload = """
    {
        "config": {
            "production": "H4sIAKw1V2EC/6tWSssvLVKyUqhWKi5JLEkFskqKSlN1FJRKKgtAPBMDILssMacUxFGqjlEqSS0uiQGyDY2Ma5VqQQozilJT8ZhgjGJCCFA7RFt5Ph5NRsiaDE1AGkoL0osSU/DZZIisCSRVWwsA+36n0OAAAAA="
        },
        "eTag": "e1d186b87842e449a2f0eea5d9f205f9460ad09b"
    }
    """
    
    func testConfigResponseDecoding() {
        let payloadData = self.payload.data(using: .utf8)!
        let response = try! JSONDecoder().decode(ConfigResponse.self, from: payloadData)
        
        XCTAssertEqual(response.eTag, "e1d186b87842e449a2f0eea5d9f205f9460ad09b")
        XCTAssertNotNil(response.config["production"])
        XCTAssertNil(response.config["development"])
        
        let config = response.config["production"]!
        
        if case let FlagType.boolean(state, value) = config["upgrade"]! {
            XCTAssertEqual(state, true)
            XCTAssertEqual(value, true)
        } else {
            XCTFail("Invalid flag type.")
        }
        
        if case let FlagType.integer(state, value) = config["two"]! {
            XCTAssertEqual(state, true)
            XCTAssertEqual(value, 14)
        } else {
            XCTFail("Invalid flag type.")
        }
        
        if case let FlagType.string(state, value) = config["three"]! {
            XCTAssertEqual(state, true)
            XCTAssertEqual(value, "Test")
        } else {
            XCTFail("Invalid flag type.")
        }
        
        if case let FlagType.json(state, value) = config["four"]! {
            XCTAssertEqual(state, true)
            XCTAssertEqual(value["test"] as! Int, 123)
        } else {
            XCTFail("Invalid flag type.")
        }
    }

    static var allTests = [
        ("testConfigResponseDecoding", testConfigResponseDecoding),
    ]
    
}
