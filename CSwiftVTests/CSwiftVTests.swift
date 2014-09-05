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

public let newLineSeparation = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00\r\n"

public let newLineSeparationNoEnd = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00"

public let withoutHeader = "1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00"

public let withRandomQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another description\",4900.00"

public let withCommasInQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another, amazing, description\",4900.00"

public let withQuotesInQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another, \"\"amazing\"\", description\",4900.00"

public let withNewLinesInQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another, \"\"amazing\"\",\ndescription\n\",4900.00\r\n"

class CSwiftVTests: XCTestCase {
   // modelling from http://tools.ietf.org/html/rfc4180#section-2
    
    var testString: String!
    
    func testThatItParsesLinesSeperatedByNewLines() {
        testString = newLineSeparation

        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)

    }
    
    func testThatItParsesLinesSeperatedByNewLinesWithoutNewLineAtEnd() {

        testString = newLineSeparationNoEnd
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesHeadersCorrectly() {
        
        testString = newLineSeparationNoEnd
        
        let arrayUnderTest : [String] =  CSwiftV(String: testString, headers:nil).headers
        
        let expectedArray = ["Year","Make","Model","Description","Price"]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesRowsWithoutHeaders() {
        
        testString = withoutHeader
        
        let arrayUnderTest = CSwiftV(String: testString, headers:["Year","Make","Model","Description","Price"]).rows
        
        //XCTAssertNil(arrayUnderTest)
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesFieldswithQuotes() {
        
        testString = withRandomQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesFieldswithCommasInQuotes() {
        
        testString = withCommasInQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, amazing, description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }

    func testThatItParsesFieldswithQuotesInQuotes() {
        
        testString = withQuotesInQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).rows as NSArray
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"amazing\", description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesFieldswithNewLinesInQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withNewLinesInQuotes", withExtension: "csv")!
        
        testString = withNewLinesInQuotes
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"amazing\",\ndescription\n","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }

}
