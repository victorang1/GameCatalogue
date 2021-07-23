//
//  DateUtil.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import Foundation

class DateUtil {
    
    static func formatDate(date: String, fromDateFormat: String = "yyyy-mm-dd", resultFormat: String) -> String {
        let fromFormatter = DateFormatter()
        fromFormatter.dateFormat = fromDateFormat
        
        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = resultFormat
        
        let newDate = fromFormatter.date(from: date)
        
        guard newDate != nil else {
            return date
        }
        
        return resultFormatter.string(from: newDate!)
    }
}
