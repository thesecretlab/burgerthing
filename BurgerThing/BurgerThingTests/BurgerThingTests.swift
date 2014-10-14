//
//  BurgerThingTests.swift
//  BurgerThingTests
//
//  Created by Timothy Rodney Nugent on 14/10/2014.
//  Copyright (c) 2014 Timothy Rodney Nugent. All rights reserved.
//

import UIKit
import XCTest

class BurgerThingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOrderBurger()
    {
        
        let expectation = expectationWithDescription("Order burger")
        
        BurgerHandler.sharedHandler.sendOrder(ingredients: ["Meat","Cheese","Relish"]) { (orderID, error) -> () in
            XCTAssertNotNil(orderID, "Order ID should not be nil")
            XCTAssertNil(error, "Error ordering burger: \(error)")
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(2.0, nil)
        
    }
    
    func testOrderBurgerFailure()
    {
        
        let expectation = expectationWithDescription("Order burger")
        
        BurgerHandler.sharedHandler.sendOrder(ingredients: []) { (orderID, error) -> () in
            XCTAssertNotNil(error, "Expected an error")
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)

    }
    
    
}
