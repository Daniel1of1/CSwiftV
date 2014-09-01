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
    
    public let columnCount: Int = 0
    public let headers : [String] = []
    public let keyedRows: [ [String:String] ] = []
    public let hasHeaders: Bool = 0
    
    public init(String string: String, header:Bool) {
        
        let lines : [String] = includeQuotedNewLinesInFields(Fields:string.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())).filter{(includeElement: String) -> Bool in
            return !includeElement.isEmpty;
        }

        
        if lines.count > 0 {
            self.columnCount = columnCountFromLine(lines[0])
            self.hasHeaders = header;
            self.headers = parseHeaders(Line: lines[0])
            self.keyedRows = self.parseRows(Lines : lines)
        }
    }
//TODO: Document that this assumes header string
    public convenience init(String string: String) {
        self.init(String: string, header: true)
    }
    
    let columnCountFromLine: (String) -> Int = { (string :String)->Int in
        return string.componentsSeparatedByString(",").count
    }
    
    func parseHeaders(Line line:String) -> [String] {
        
        let numberOfRows = line.componentsSeparatedByString(",").count
        
        var headerRows :[String] = []
        
        if (!hasHeaders) {
            for i in 1...numberOfRows {
                headerRows.append("column\(i)")
            }
            
            return headerRows;
        }
        
        else {
            return sanitizedFields(Fields: line.componentsSeparatedByString(","))

            
        }
        
    }
    
    func parseRows(Lines lines:[String]) -> [ [String:String] ] {
        
        var rows = [ [String:String] ]()
        
        for (lineNumber, line) in enumerate(lines) {
            if (self.hasHeaders && lineNumber == 0) {
                continue
            }
            var row = [String:String]()
            
            let commaSanitized = includeQuotedCommasInFields(Fields: line.componentsSeparatedByString(","))
            
            let quoteSanitized = sanitizedFields(Fields: commaSanitized)
            
            let fields = includeQuotedQuotesInFields(Fields: quoteSanitized)
            
            for (index, header) in enumerate(self.headers) {
                let field : String = fields[index]
                row[header] = field
            }
            
            rows.append(row)
        }
        
        return rows
    }
    
//MARK: Helpers
    
    func includeQuotedNewLinesInFields(Fields fields: [String]) -> [String] {
        
        var mergedField = ""
        
        var newArray = [String]()
        
        for field in fields {
            mergedField += field
            if (mergedField.componentsSeparatedByString("\"").count%2 != 1) {
                mergedField += "\n"
                continue
            }
            newArray.append(mergedField);
            mergedField = ""
        }
        
        return newArray;
    }

    
    func includeQuotedCommasInFields(Fields fields: [String]) -> [String] {
        
        var mergedField = ""
        
        var newArray = [String]()
        
        for field in fields {
            mergedField += field
            if (mergedField.componentsSeparatedByString("\"").count%2 != 1) {
                mergedField += ","
                continue
            }
            newArray.append(mergedField);
            mergedField = ""
        }
        
        return newArray;
    }
    
    func includeQuotedQuotesInFields(Fields fields: [String]) -> [String] {
        
        return fields.map{(var inputString) -> String in
            return inputString.stringByReplacingOccurrencesOfString("\"\"", withString: "\"", options: NSStringCompareOptions.LiteralSearch)
            }
    }

    
    func sanitizedFields(Fields fields:[String]) -> [String] {
        
        var sanitized: [String] = []
        
        for field in fields {
            let doubleQuote : String = "\""
            
            let startsWithQuote: Bool = field.hasPrefix("\"");
            let endsWithQuote: Bool = field.hasSuffix("\"");
            
            if (startsWithQuote && endsWithQuote) {
                let startIndex = advance(field.startIndex, 1)
                let endIndex = advance(field.endIndex,-1)
                let range = startIndex..<endIndex
                
                let sanitizedField: String = field.substringWithRange(range)
                
                sanitized.append(sanitizedField);
            }
            else {
                sanitized.append(field)
            }
        }
        
        return sanitized
    }

}
