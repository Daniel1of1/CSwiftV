//
//  CSwiftV.swift
//  CSwiftV
//
//  Created by Daniel Haight on 30/08/2014.
//  Copyright (c) 2014 ManyThings. All rights reserved.
//

import Foundation

//TODO: make these prettier and probably not extensions
public extension String {
    func splitOnNewLine () -> ([String]) {
        return self.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
}

//MARK: Parser
public class CSwiftV {

    public let columnCount: Int
    public let headers: [String]
    public let keyedRows: [[String: String]]?
    public let rows: [[String]]

    public init(String string: String, separator:String = ",", headers:[String]? = nil) {

        var parsedLines = recordsFromString(string.stringByReplacingOccurrencesOfString("\r\n", withString: "\n")).map { cellsFromString($0, separator: separator) }

        let tempHeaders : [String]

        if let unwrappedHeaders = headers {
            tempHeaders = unwrappedHeaders
        }
        else {
            tempHeaders = parsedLines[0]
            parsedLines.removeAtIndex(0)
        }

        self.rows = parsedLines

        self.columnCount = tempHeaders.count

        let keysAndRows = self.rows.map { (field :[String]) -> [String:String] in

            var row = [String:String]()

            for (index, value) in field.enumerate() {
                row[tempHeaders[index]] = value
            }

            return row
        }

        self.keyedRows = keysAndRows
        self.headers = tempHeaders
    }

    public convenience init(String string: String, headers:[String]?) {
        self.init(String: string, headers:headers, separator:",")
    }

}

func cellsFromString(rowString:String, separator: String = ",") -> [String] {

    return split(separator, string: rowString).map { element in
        if let first = element.characters.first, let last = element.characters.last {
            if (first == "\"" && last == "\"" ) {
                let range = Range(start: element.startIndex.successor() , end: element.endIndex.predecessor())
                return element.substringWithRange(range)
            }
        }
        return element
    }
}

func recordsFromString(string: String) -> [String] {

    return split("\n", string: string)

}

func split(separator: String, string: String) -> [String] {

    let initial = string.componentsSeparatedByString(separator)

    func oddNumberOfQuotes(string: String) -> Bool {
        return string.componentsSeparatedByString("\"").count % 2 == 0
    }

    let merged = initial.reduce([]) { (prevArray, newString) -> [String] in

        if let record = prevArray.last {
            if (oddNumberOfQuotes(record)) {
                var newArray = prevArray
                newArray.removeLast()
                let lastElem = record + separator + newString
                newArray.append(lastElem)
                return newArray
            } else {
                return prevArray + [newString]
            }
        } else {
            return prevArray + [newString]
        }

    }

    let final = merged
        .filter { (string) -> Bool in return string.characters.count > 0 }
    
    
    return final

}
