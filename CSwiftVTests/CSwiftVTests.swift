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

public let emptyColumns = "Year,Make,Model,Description,Price\r\n1997,Ford,,descrition,3000.00\r\n1999,Chevy,Venture,another description,\r\n"


public let newLineSeparation = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00\r\n"

public let newLineSeparationNoCR = "Year,Make,Model,Description,Price\n1997,Ford,E350,descrition,3000.00\n1999,Chevy,Venture,another description,4900.00\n"

public let newLineSeparationNoEnd = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00"

public let withoutHeader = "1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00"

public let withRandomQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another description\",4900.00"

public let withCommasInQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another, amazing, description\",4900.00"

public let withQuotesInQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another, \"\"amazing\"\", description\",4900.00"

public let withNewLinesInQuotes = "Year,Make,Model,Description,Price\n1997,Ford,\"E350\",descrition,3000.00\n1999,Chevy,Venture,\"another, \"\"amazing\"\",\n\ndescription\n\",4900.00\n"

public let withTabSeparator = "Year\tMake\tModel\tDescription\tPrice\r\n1997\tFord\t\"E350\"\tdescrition\t3000.00\r\n1999\tChevy\tVenture\t\"another\t \"\"amazing\"\"\t description\"\t4900.00\r\n"

public let singleString = "1999,Chevy,Venture,\"another, \"\"amazing\"\",\n\ndescription\n\",4900.00"

class CSwiftVTests: XCTestCase {
    
    var testString: String!

   // modelling from http://tools.ietf.org/html/rfc4180#section-2
    
    //1.  Each record is located on a separate line, delimited by a line
    //break (CRLF).  For example:
    
    //aaa,bbb,ccc CRLF
    //zzz,yyy,xxx CRLF
    func testThatItParsesLinesSeperatedByNewLines() {
        testString = newLineSeparation

        let arrayUnderTest =  CSwiftV(String: testString).rows

        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]

        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }

    func testThatItParsesLinesSeperatedByNewLinesNoCR() {
        testString = newLineSeparationNoCR

        let arrayUnderTest =  CSwiftV(String: testString).rows

        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]

        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }

    //2.  The last record in the file may or may not have an ending line
    //break.  For example:
    
    //aaa,bbb,ccc CRLF
    //zzz,yyy,xxx
    
    func testThatItParsesLinesSeperatedByNewLinesWithoutNewLineAtEnd() {

        testString = newLineSeparationNoEnd
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    //3.  There maybe an optional header line appearing as the first line
    //of the file with the same format as normal record lines.  This
    //header will contain names corresponding to the fields in the file
    //and should contain the same number of fields as the records in
    //the rest of the file (the presence or absence of the header line
    //should be indicated via the optional "header" parameter of this
    //MIME type).  For example:
    
    //field_name,field_name,field_name CRLF
    //aaa,bbb,ccc CRLF
    //zzz,yyy,xxx CRLF
    func testThatItParsesHeadersCorrectly() {
        
        testString = newLineSeparationNoEnd
        
        let arrayUnderTest : [String] =  CSwiftV(String: testString).headers
        
        let expectedArray = ["Year","Make","Model","Description","Price"]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    // still 3. in RFC. This is the first decision we make in
    // api design with regards to headers. Currently if nothing
    // is passed in to the `headers` parameter (as is the case)
    // with the convenience initialiser. We assume that the csv
    // contains headers. If the headers are passed in, then we
    // assume that the csv file does not contain them and expect
    // it to be parsed accordingly.
    func testThatItParsesRowsWithoutHeaders() {
        
        testString = withoutHeader
        
        let arrayUnderTest = CSwiftV(String: testString, separator:",", headers:["Year","Make","Model","Description","Price"]).rows
        
        //XCTAssertNil(arrayUnderTest)
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    
//    4.  Within the header and each record, there may be one or more
//    fields, separated by commas.  Each line should contain the same
//    number of fields throughout the file.  Spaces are considered part
//    of a field and should not be ignored.  The last field in the
//    record must not be followed by a comma.  For example:
//    
//    aaa,bbb,ccc
//    
//    This is covered by previous test cases since there are spaces in 
//    fields and no commas at the end of the lines
//    
//    5.  Each field may or may not be enclosed in double quotes (however
//    some programs, such as Microsoft Excel, do not use double quotes
//    at all).  If fields are not enclosed with double quotes, then
//    double quotes may not appear inside the fields.  For example:
//    
//    "aaa","bbb","ccc" CRLF
//    zzz,yyy,xxx
    func testThatItParsesFieldswithQuotes() {
        
        testString = withRandomQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
//    6.  Fields containing line breaks (CRLF), double quotes, and commas
//    should be enclosed in double-quotes.  For example:
//    
//    "aaa","b CRLF
//    bb","ccc" CRLF
//    zzz,yyy,xxx

    func testThatItParsesFieldswithCommasInQuotes() {
        
        testString = withCommasInQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, amazing, description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItParsesFieldswithNewLinesInQuotes() {
        
        testString = withNewLinesInQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"\"amazing\"\",\n\ndescription\n","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
//    7.  If double-quotes are used to enclose fields, then a double-quote
//    appearing inside a field must be escaped by preceding it with
//    another double quote.  For example:
//    
//    "aaa","b""bb","ccc"

    func testThatItParsesFieldswithQuotesInQuotes() {
        
        testString = withQuotesInQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"\"amazing\"\", description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatCanReturnKeyedRows() {
        
        testString = withQuotesInQuotes
        
        let arrayUnderTest =  CSwiftV(String: testString).keyedRows!
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another, \"\"amazing\"\", description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }
    
    func testThatItCanParseArbitrarySeparators() {
        
        testString = withTabSeparator
        
        let arrayUnderTest =  CSwiftV(String: testString, separator:"\t").keyedRows!
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another\t \"\"amazing\"\"\t description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest, expectedArray)
        
    }

    func testThatItCanGetCellsFromAstring() {
        testString = withNewLinesInQuotes

        let arrayUnderTest =  recordsFromString(testString)

        let expectedArray = [
            "Year,Make,Model,Description,Price",
            "1997,Ford,\"E350\",descrition,3000.00",
            "1999,Chevy,Venture,\"another, \"\"amazing\"\",\n\ndescription\n\",4900.00"
        ]

        XCTAssertEqual(arrayUnderTest, expectedArray)
    }


    func testThatItCanGetCells() {
        testString = singleString

        let arrayUnderTest =  cellsFromString(testString)

        let expectedArray = [
            "1999",
            "Chevy",
            "Venture",
            "another, \"\"amazing\"\",\n\ndescription\n",
            "4900.00"
        ]

        XCTAssertEqual(arrayUnderTest, expectedArray)
    }

    func testWhenCellsAreEmpty() {
        
        testString = emptyColumns
        let csv = CSwiftV(String: testString)
        
        let expectedArray = [
            ["1997","Ford","","descrition","3000.00"],
            ["1997","Ford","","descrition","3000.00"],
            ["1999","Chevy","Venture","another description",""]
        ]
        
        XCTAssertEqual(csv.rows, expectedArray)
        
        let expectedKeyedRows = [
            ["Year":"Year", "Make": "Make", "Description":"Description", "Price":"Price"],
            ["Year":"1997", "Make": "Ford", "Description":"descrition", "Price":"3000.00"],
            ["Year":"1999", "Make": "Chevy", "Model":"Venture", "Description":"another description"]
        ]
        
        XCTAssertEqual(csv.keyedRows!, expectedKeyedRows)
    }

    
}
