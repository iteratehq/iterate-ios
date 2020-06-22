//
//  EmbedEndpointTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import Iterate

class EmbedEndpointTests: XCTestCase {
    
    /// Test embed method passes the correct path and encodes the data correctly
    func testEmbed() {
        // Mock the post method of APIClient
        class APIClientMock: APIClient {
            override func post<T: Codable>(path: Path, data: Data?, complete: @escaping (T?, Error?) -> Void) {
                var embedContext: EmbedContext?
                if let data = data {
                    embedContext = try? decoder.decode(EmbedContext.self, from: data)
                }
                
                XCTAssertEqual(path, Paths.Surveys.Embed)
                XCTAssertEqual(embedContext?.type, EmbedType.mobile)
                
                complete(nil, nil)
            }
        }
        
        let context = EmbedContext(targeting: nil, trigger: nil, type: EmbedType.mobile)
        let client = APIClientMock(apiKey: testCompanyApiKey)
        
        let embedComplete = expectation(description: "Embed complete")
        client.embed(context: context) { (response, error) in
            embedComplete.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
