//
//  EmbedEndpointTests.swift
//  IterateTests
//
//  Created by Michael Singleton on 1/1/20.
//  Copyright © 2020 Pickaxe LLC. (DBA Iterate). All rights reserved.
//

import XCTest
@testable import IterateSDK

class EmbedEndpointTests: XCTestCase {
    
    /// Test embed method passes the correct path and encodes the data correctly
    func testEmbed() {
        // Mock the post method of APIClient
        class APIClientMock: APIClient {
            override func post<T: Codable>(_ data: Data?, to path: Path, completion: @escaping (T?, Error?) -> Void) {
                var embedContext: EmbedContext?
                if let data = data {
                    embedContext = try? decoder.decode(EmbedContext.self, from: data)
                }
                
                XCTAssertEqual(path, Paths.surveys.embed)
                XCTAssertEqual(embedContext?.type, EmbedType.mobile)
                
                completion(nil, nil)
            }
        }
        
        let iterate = Iterate(storage: MockStorageEngine())
        let context = EmbedContext(iterate)
        let client = APIClientMock(apiKey: testCompanyApiKey)
        
        let embedComplete = expectation(description: "Embed complete")
        client.embed(context: context) { (response, error) in
            embedComplete.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
}
