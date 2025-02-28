//
//  File.swift
//  SwiftUICC
//
//  Created by woong on 2/2/25.
//

import Foundation

enum YearType {
    
    /// Returns the last two digits of the given year as a string.
    ///
    /// This function converts the provided integer year into a string, then extracts and returns its last two characters.
    ///
    /// For example:
    /// - When the year is 2025, it returns "25".
    /// - When the year is 2205, it returns "05".
     
    case YY
    
    /// Returns the full year as a string.
    ///
    /// This function converts the given integer year into its full string representation.
    ///
    /// For example:
    /// - When the input is 2025, it returns "2025".
    /// - When the input is 2205, it returns "2205".
    case YYYY
}
