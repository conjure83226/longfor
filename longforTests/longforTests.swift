//
//  longforTests.swift
//  longforTests
//
//  Created by jack on 2020/5/2.
//  Copyright © 2020 home. All rights reserved.
//

import XCTest
@testable import longfor

class longforTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let data = JCRequestData()
        data.path = app.datastore_search()
        data.params["resource_id"] = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f";
        data.params["q"] = "jones";
        let setup = JCRequestSetup()
        setup.requestDatas.append(data)
        let _ = JCRequest.post(setup: setup, success: { (datas:Array<JCRequestData>) in
        }, failed: { (data:JCRequestData) in
        }, end: {
        })
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
