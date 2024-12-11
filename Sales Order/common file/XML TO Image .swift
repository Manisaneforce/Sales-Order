//
//  XML TO Image .swift
//  Sales Order
//
//  Created by Anbu j on 10/12/24.
//


import SwiftUI

class XMLParserUtility {
    static func extractBase64(from xml: String, tagName: String) -> String? {
        let openingTag = "<\(tagName)>"
        let closingTag = "</\(tagName)>"
        guard let startRange = xml.range(of: openingTag),
              let endRange = xml.range(of: closingTag) else { return nil }
        return String(xml[startRange.upperBound..<endRange.lowerBound])
    }
}



import Foundation

class DateUtils {
    static func formatDate(_ dateString: String, from inputFormat: String, to outputFormat: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = outputFormat
            return outputFormatter.string(from: date)
        } else {
            return dateString // Return the original string if formatting fails
        }
    }
}
