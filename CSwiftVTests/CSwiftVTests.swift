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
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("newLineSeparation", withExtension: "csv")
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)

        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())

    }
    
    func testThatItParsesLinesSeperatedByNewLinesWithoutNewLineAtEnd() {
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("newLineSeparationNoEnd", withExtension: "csv")
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())
        
    }
    
    func testThatItParsesHeadersCorrectly() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("newLineSeparationNoEnd", withExtension: "csv")
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)
        
        let arrayUnderTest : [String] =  CSwiftV(String: testString, header:true).headers
        
        let expectedArray = ["Year","Make","Model","Description","Price"]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())
        
    }
    
    func testThatItParsesRowsWithoutHeaders() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withoutHeader", withExtension: "csv")
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)
        
        let arrayUnderTest = CSwiftV(String: testString, header:false).rows
        
        //XCTAssertNil(arrayUnderTest)
        
        let expectedArray = [
            ["column1":"1997","column2":"Ford","column3":"E350","column4":"descrition","column5":"3000.00"],
            ["column1":"1999","column2":"Chevy","column3":"Venture","column4":"another description","column5":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())
        
    }
    
    func testThatItParsesFieldswithQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withRandomQuotes", withExtension: "csv")
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())
        
    }
    
    func testThatItParsesFieldswithCommasInQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withCommasInQuotes", withExtension: "csv")
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another, amazing, description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())
        
    }

    func testThatItParsesFieldswithQuotesInQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withQuotesInQuotes", withExtension: "csv")
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another, \"amazing\", description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())
        
    }
    
    func testThatItParsesFieldswithNewLinesInQuotes() {
        
        let testCSVURL = NSBundle(forClass:CSwiftVTests.self).URLForResource("withNewLinesInQuotes", withExtension: "csv")
        
        testString = NSString.stringWithContentsOfURL(testCSVURL, encoding:NSUTF8StringEncoding, error:nil)
        println("\(testString!)")
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another, \"amazing\",\ndescription\n","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest.bridgeToObjectiveC(), expectedArray.bridgeToObjectiveC())
        
    }

}
