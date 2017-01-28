//
//  Date.swift
//  PinterestHome
//
//  Created by Sauvik Dolui on 27/01/17.
//  Copyright © 2017 Sauvik Dolui. All rights reserved.
//

import Foundation



public enum ISO8601Format: String {
    
    case Year = "yyyy" // 1997
    case YearMonth = "yyyy-MM" // 1997-07
    case Date = "yyyy-MM-dd" // 1997-07-16
    case DateTime = "yyyy-MM-dd'T'HH:mmZ" // 1997-07-16T19:20+01:00
    case DateTimeSec = "yyyy-MM-dd'T'HH:mm:ssZ" // 1997-07-16T19:20:30+01:00
    case DateTimeMilliSec = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 1997-07-16T19:20:30.45+01:00
    
    init(dateString:String) {
        switch dateString.characters.count {
        case 4:
            self = ISO8601Format(rawValue: ISO8601Format.Year.rawValue)!
        case 7:
            self = ISO8601Format(rawValue: ISO8601Format.YearMonth.rawValue)!
        case 10:
            self = ISO8601Format(rawValue: ISO8601Format.Date.rawValue)!
        case 22:
            self = ISO8601Format(rawValue: ISO8601Format.DateTime.rawValue)!
        case 25:
            self = ISO8601Format(rawValue: ISO8601Format.DateTimeSec.rawValue)!
        default:// 28:
            self = ISO8601Format(rawValue: ISO8601Format.DateTimeMilliSec.rawValue)!
        }
    }
    var formatter: DateFormatter {
        let formatter =  DateFormatter()
        formatter.dateFormat = self.rawValue
        return formatter
    }
}

extension Date {
    
    // MARK: - Date Calculations
    
    /// Generates a date string from date object following a provided DateFormatter String
    ///
    /// - Parameters:
    ///   - formatString: Date format string
    ///   - date: Date to be converted to string
    /// - Returns: Date String
    static func getDateStringFromFormat(formatString: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: date)
    }
    
    /// Generates a date string from date object in ISO8601 Format
    ///
    /// - Parameter date: Date to be converted
    /// - Returns: Date string in ISO8601 format
    static func getISO8601DateString(date: Date) -> String {
        return getDateStringFromFormat(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", date: date)
    }
    
    static func date(from string: String, format: ISO8601Format) -> Date? {
        return format.formatter.date(from: string)
    }
}
