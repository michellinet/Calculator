//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Michelline Tran on 3/14/17.
//  Copyright © 2017 Michelline Tran. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    var brain = CalculatorBrain()
    
    override func setUp() {
        super.setUp()
        
        brain = CalculatorBrain()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        brain.setOperand(5)
        
        let result = brain.evaluate()
        let value = result.result
        XCTAssertEqual(value, 5.0)
        
    }
    
    func testTwo() {
        
        brain.setOperand(variable: "x")
        
        let result = brain.evaluate(using: ["x": 5.0])
        let value = result.result
        XCTAssertEqual(value, 5.0)
    }
    
    func testThree() {
        
        brain.setOperand(3.0)
        brain.performOperation("+")
        brain.setOperand(7.0)
        
        let result = brain.evaluate()
        let value = result.result
        
        XCTAssertEqual(value, 10.0)
        
    }
    
    func testFour() {
        
        brain.setOperand(5.0)
        brain.performOperation("+")
        brain.setOperand(variable: "x")
        
        let result = brain.evaluate(using: ["x": 93.0])
        let value = result.result
        
        XCTAssertEqual(value, 98.0)
    }
    
    func testSix() {
    
        brain.setOperand(5.0)
        brain.performOperation("±")
    
        let result = brain.evaluate()
        let value = result.result
    
        XCTAssertEqual(value, -5.0)
    }
    
    func testSeven() {
        
        brain.setOperand(16.0)
        brain.performOperation("√")
        
        let result = brain.evaluate()
        let value = result.result
        
        XCTAssertEqual(value, 4.0)
    }
    
    func testEight() {
        
        brain.setOperand(10.0)
        brain.performOperation("×")
        
        let result = brain.evaluate()
        let status = result.isPending
        
        XCTAssertEqual(status, true)
        
    }

    func testNine() {
        
        brain.setOperand(10.0)
        
        let result = brain.evaluate()
        let status = result.isPending
        
        XCTAssertEqual(status, false)
    }
    
    func testTen() {
        brain.setOperand(3.0)
        brain.performOperation("+")
        brain.setOperand(7.0)
        
        let result = brain.evaluate()
        let status = result.isPending
        
        XCTAssertEqual(status, false)
        
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
