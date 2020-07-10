//
//  ClientTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 12/30/19.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

class ClientTests: XCTestCase {
    
    /// Test that the post method creates a request with the correct configuration
    func testPost() {
        // Mock the dataTask method of APIClient
        class APIClientMock: APIClient {
            override func dataTask<T: Codable>(request: URLRequest, complete: @escaping (T?, Error?) -> Void) {
                let embedContext = try! decoder.decode(EmbedContext.self, from: request.httpBody!)
                
                XCTAssertEqual(request.url?.absoluteString, "\(Iterate.DefaultAPIHost)/api/v1\(Paths.Surveys.Embed)")
                XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type")!, "application/javascript")
                XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization")!, "Bearer \(testCompanyApiKey)")
                XCTAssertEqual(request.httpMethod, "POST")
                XCTAssertEqual(embedContext.type, EmbedType.mobile)
                
                complete(nil, nil)
            }
        }
        
        let client = APIClientMock(apiKey: testCompanyApiKey)
        let context = EmbedContext(targeting: nil, trigger: nil, type: EmbedType.mobile)
        let data = try! client.encoder.encode(context)
        
        let postComplete = expectation(description: "Post complete")
        client.post(data, to: Paths.Surveys.Embed) { (response: EmbedResponse?, error) in
            postComplete.fulfill()
        }
         waitForExpectations(timeout: 3)
    }
}

