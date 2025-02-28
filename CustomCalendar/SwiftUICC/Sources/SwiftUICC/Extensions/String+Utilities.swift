//
//  File.swift
//  SwiftUICC
//
//  Created by woong on 2/2/25.
//

import Foundation

extension String {
    
    func toDate() -> Date {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.autoupdatingCurrent
        
        if let date = df.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
