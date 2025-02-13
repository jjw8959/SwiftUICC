//
//  File.swift
//  SwiftUICC
//
//  Created by woong on 2/11/25.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}
