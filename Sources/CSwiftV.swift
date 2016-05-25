//
//  CSwiftV.swift
//  CSwiftV
//
//  Created by Daniel Haight on 30/08/2014.
//  Copyright (c) 2014 ManyThings. All rights reserved.
//

import class Foundation.NSCharacterSet

extension String {

    var isEmptyOrWhitespace: Bool {
        return characters.isEmpty ? true : trimmingCharacters(in: .whitespaces()) == ""
    }

    var isNotEmptyOrWhitespace: Bool {
        return !isEmptyOrWhitespace
    }

}

// MARK: Parser
public class CSwiftV {

    private let columnCount: Int
    public let headers: [String]
    public let keyedRows: [[String: String]]?
    public let rows: [[String]]

    public init(string: String, separator: String = ",", headers: [String]? = nil) {
        var parsedLines = CSwiftV.recordsFromString(string:string.replacingOccurrences(of: "\r\n", with: "\n")).map { CSwiftV.cellsFromString(rowString:$0, separator: separator) }
        self.headers = headers ?? parsedLines.removeFirst()
        rows = parsedLines
        columnCount = self.headers.count

        let tempHeaders = self.headers
        keyedRows = rows.map { field -> [String: String] in
            var row = [String: String]()
            //only store value which are not empty
            for (index, value) in field.enumerated() where value.isNotEmptyOrWhitespace {
                row[tempHeaders[index]] = value
            }
            return row
        }
    }

    public convenience init(string: String, headers: [String]?) {
        self.init(string: string, headers:headers, separator:",")
    }

    internal static func cellsFromString(rowString: String, separator: String = ",") -> [String] {
        return CSwiftV.split(separator: separator, string: rowString).map { element in
            if let first = element.characters.first, let last = element.characters.last where first == "\"" && last == "\"" {
                let result = String(element.characters.dropFirst().dropLast())
                return result
            }
            return element
        }
    }

    internal static func recordsFromString(string: String) -> [String] {
        return  CSwiftV.split(separator: "\n", string: string).filter { ($0 as String).isNotEmptyOrWhitespace }
    }

    private static func split(separator: String, string: String) -> [String] {

        func oddNumberOfQuotes(string: String) -> Bool {
            return string.components(separatedBy: "\"").count % 2 == 0
        }

        let initial = string.components(separatedBy: separator)
        var merged = [String]()
        for newString in initial {
            guard let record = merged.last where oddNumberOfQuotes(string: record) == true else {
                merged.append(newString)
                continue
            }
            merged.removeLast()
            let lastElem = record + separator + newString
            merged.append(lastElem)
        }
        return merged
    }

}
