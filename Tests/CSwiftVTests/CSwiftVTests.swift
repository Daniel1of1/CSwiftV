//
//  CSwiftVTests.swift
//  CSwiftVTests
//
//  Created by Daniel Haight on 30/08/2014.
//  Copyright (c) 2014 ManyThings. All rights reserved.
//

import Foundation
import XCTest

@testable import CSwiftV

public let emptyColumns = "Year,Make,Model,Description,Price\r\n1997,Ford,,descrition,3000.00\r\n1999,Chevy,Venture,another description,\r\n"

public let newLineSeparation = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00\r\n"

public let newLineSeparationNoCR = "Year,Make,Model,Description,Price\n1997,Ford,E350,descrition,3000.00\n1999,Chevy,Venture,another description,4900.00\n"

public let newLineSeparationNoEnd = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00"

public let withoutHeader = "1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00"

public let longerColumns = "Year,Make,Model,Description,Price\r\n1997,Ford,E350,descrition,3000.00\r\n1999,Chevy,Venture,another description,4900.00,extra column\r\n"

public let withRandomQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another description\",4900.00"

public let withCommasInQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another, amazing, description\",4900.00"

public let withQuotesInQuotes = "Year,Make,Model,Description,Price\r\n1997,Ford,\"E350\",descrition,3000.00\r\n1999,Chevy,Venture,\"another, \"\"amazing\"\", description\",4900.00"

public let withNewLinesInQuotes = "Year,Make,Model,Description,Price\n1997,Ford,\"E350\",descrition,3000.00\n1999,Chevy,Venture,\"another, \"\"amazing\"\",\n\ndescription\n\",4900.00\n"

public let withTabSeparator = "Year\tMake\tModel\tDescription\tPrice\r\n1997\tFord\t\"E350\"\tdescrition\t3000.00\r\n1999\tChevy\tVenture\t\"another\t \"\"amazing\"\"\t description\"\t4900.00\r\n"

public let singleString = "1999,Chevy,Venture,\"another, \"\"amazing\"\",\n\ndescription\n\",4900.00"

class CSwiftVTests: XCTestCase {

    lazy var nativeSwiftStringCSV: String = {
        var string = "Timestamp,Number1,Number2"
        for _ in 1...10_000 {
            string += ("20150101000100,100,0\n")
        }
        return string
    }()

    var testString: String!

   // modelling from http://tools.ietf.org/html/rfc4180#section-2
    
    //1.  Each record is located on a separate line, delimited by a line
    //break (CRLF).  For example:
    
    //aaa,bbb,ccc CRLF
    //zzz,yyy,xxx CRLF
    func testThatItParsesLinesSeperatedByNewLines() {
        testString = newLineSeparation

        let arrayUnderTest =  CSwiftV(with: testString).rows

        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]

        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }

    func testThatItParsesLinesSeperatedByNewLinesNoCR() {
        testString = newLineSeparationNoCR

        let arrayUnderTest =  CSwiftV(with: testString).rows

        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]

        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }

    //2.  The last record in the file may or may not have an ending line
    //break.  For example:
    
    //aaa,bbb,ccc CRLF
    //zzz,yyy,xxx
    
    func testThatItParsesLinesSeperatedByNewLinesWithoutNewLineAtEnd() {

        testString = newLineSeparationNoEnd
        
        let arrayUnderTest =  CSwiftV(with: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
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
        
        let arrayUnderTest : [String] =  CSwiftV(with: testString).headers
        
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
        
        let arrayUnderTest = CSwiftV(with: testString, separator:",", headers:["Year","Make","Model","Description","Price"]).rows
        
        //XCTAssertNil(arrayUnderTest)
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }

    // Covers the case where a row is longer than the header row.
    func testThatItParsesRowsLongerThanHeaders() {

        testString = longerColumns
        let csv = CSwiftV(with: testString)

        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00","extra column"]
        ]

        XCTAssertEqual(csv.rows[0], expectedArray[0])
        XCTAssertEqual(csv.rows[1], expectedArray[1])

        let expectedKeyedRows = [
            ["Year":"1997", "Make": "Ford", "Model": "E350", "Description": "descrition", "Price":"3000.00"],
            ["Year":"1999", "Make": "Chevy", "Model": "Venture", "Description":"another description", "Price":"4900.00"]
        ]

        XCTAssertEqual(csv.keyedRows![0], expectedKeyedRows[0])
        XCTAssertEqual(csv.keyedRows![1], expectedKeyedRows[1])
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
        
        let arrayUnderTest =  CSwiftV(with: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }
    
//    6.  Fields containing line breaks (CRLF), double quotes, and commas
//    should be enclosed in double-quotes.  For example:
//    
//    "aaa","b CRLF
//    bb","ccc" CRLF
//    zzz,yyy,xxx

    func testThatItParsesFieldswithCommasInQuotes() {
        
        testString = withCommasInQuotes
        
        let arrayUnderTest =  CSwiftV(with: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, amazing, description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }
    
    func testThatItParsesFieldswithNewLinesInQuotes() {
        
        testString = withNewLinesInQuotes
        
        let arrayUnderTest =  CSwiftV(with: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"\"amazing\"\",\n\ndescription\n","4900.00"]
        ]

        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }
    
//    7.  If double-quotes are used to enclose fields, then a double-quote
//    appearing inside a field must be escaped by preceding it with
//    another double quote.  For example:
//    
//    "aaa","b""bb","ccc"

    func testThatItParsesFieldswithQuotesInQuotes() {
        
        testString = withQuotesInQuotes
        
        let arrayUnderTest =  CSwiftV(with: testString).rows
        
        let expectedArray = [
            ["1997","Ford","E350","descrition","3000.00"],
            ["1999","Chevy","Venture","another, \"\"amazing\"\", description","4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }
    
    func testThatCanReturnKeyedRows() {
        
        testString = withQuotesInQuotes
        
        let arrayUnderTest =  CSwiftV(with: testString).keyedRows!
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another, \"\"amazing\"\", description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }
    
    func testThatItCanParseArbitrarySeparators() {
        
        testString = withTabSeparator
        
        let arrayUnderTest =  CSwiftV(with: testString, separator:"\t").keyedRows!
        
        let expectedArray = [
            ["Year":"1997","Make":"Ford","Model":"E350","Description":"descrition","Price":"3000.00"],
            ["Year":"1999","Make":"Chevy","Model":"Venture","Description":"another\t \"\"amazing\"\"\t description","Price":"4900.00"]
        ]
        
        XCTAssertEqual(arrayUnderTest[0], expectedArray[0])
        XCTAssertEqual(arrayUnderTest[1], expectedArray[1])
    }

    func testThatItCanGetCellsFromAstring() {
        testString = withNewLinesInQuotes

        let arrayUnderTest = CSwiftV.records(from: testString)

        let expectedArray = [
            "Year,Make,Model,Description,Price",
            "1997,Ford,\"E350\",descrition,3000.00",
            "1999,Chevy,Venture,\"another, \"\"amazing\"\",\n\ndescription\n\",4900.00"
        ]

        XCTAssertEqual(arrayUnderTest, expectedArray)
    }


    func testThatItCanGetCells() {
        testString = singleString

        let arrayUnderTest = CSwiftV.cells(forRow: testString)

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
        let csv = CSwiftV(with: testString)
        
        let expectedArray = [
            ["1997","Ford","","descrition","3000.00"],
            ["1999","Chevy","Venture","another description",""]
        ]
        
        XCTAssertEqual(csv.rows[0], expectedArray[0])
        XCTAssertEqual(csv.rows[1], expectedArray[1])

        let expectedKeyedRows = [
            ["Year":"1997", "Make": "Ford", "Description":"descrition", "Price":"3000.00"],
            ["Year":"1999", "Make": "Chevy", "Model":"Venture", "Description":"another description"]
        ]
        
        XCTAssertEqual(csv.keyedRows![0], expectedKeyedRows[0])
        XCTAssertEqual(csv.keyedRows![1], expectedKeyedRows[1])
    }

    func testPerformance() {
        let testString = nativeSwiftStringCSV
        measure {
            let _ = CSwiftV(with: testString)
        }
    }

}
