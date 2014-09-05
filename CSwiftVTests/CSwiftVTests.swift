//
//  CSwiftVTests.swift
//  CSwiftVTests
//
//  Created by Daniel Haight on 30/08/2014.
//  Copyright (c) 2014 ManyThings. All rights reserved.
//

import Foundation
import XCTest

import CSwiftV

class CSwiftVTests: XCTestCase {
    
    var testString: String!
    
    override func setUp() {
        super.setUp()
    }
    
    func testThatItParsesLinesSeperatedByNewLines() {
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("newLineSeparation", withExtension: "csv")!
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!

        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)

    }
    
    func testThatItParsesLinesSeperatedByNewLinesWithoutNewLineAtEnd() {
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("newLineSeparationNoEnd", withExtension: "csv")!
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesHeadersCorrectly() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("newLineSeparationNoEnd", withExtension: "csv")!
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!
        
        let arrayUnderTest : [String] =  CSwiftV(String: testString, headers:nil).headers
        
        let expectedArray = ["Year","Make","Model","Description","Price"]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesRowsWithoutHeaders() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withoutHeader", withExtension: "csv")!
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!
        
        let arrayUnderTest = CSwiftV(String: testString, headers:["Year","Make","Model","Description","Price"]).rows
        
        //XCTAssertNil(arrayUnderTest)
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesFieldswithQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withRandomQuotes", withExtension: "csv")!
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesFieldswithCommasInQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withCommasInQuotes", withExtension: "csv")!
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, amazing, description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }

    func testThatItParsesFieldswithQuotesInQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withQuotesInQuotes", withExtension: "csv")!
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!
        
        let arrayUnderTest =  CSwiftV(String: testString).rows as NSArray
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"amazing\", description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesFieldswithNewLinesInQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withNewLinesInQuotes", withExtension: "csv")!
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)!
        println("\(testString!)")
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"amazing\",\ndescription\n","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }

}
