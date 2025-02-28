//
//  MonthType.swift
//  SwiftUICC
//
//  Created by woong on 2/2/25.
//

import Foundation

/// 헤더에 표시되는 달을 지정하기 위한 타입
enum MonthType {
    /// Returns a string representation of the given month without leading zeros.
    ///
    /// This function takes an integer representing the month and returns its string representation.
    /// For single-digit months, no leading zero is included.
    ///
    /// For example:
    /// - If the month is January (represented by 1), it returns "1".
    /// - If the month is October (represented by 10), it returns "10".
    case M
    
    /// Returns a two-digit string representation of the given month.
    ///
    /// This function takes an integer representing the month and returns its string representation,
    /// ensuring that single-digit months are padded with a leading zero.
    ///
    /// For example:
    /// - If the month is January (represented by 1), it returns "01".
    /// - If the month is October (represented by 10), it returns "10".
    case MM
    
    /// Returns a three-letter abbreviation of the given month.
    ///
    /// This function converts an integer representing the month into its corresponding
    /// three-letter abbreviation (e.g., "Jan" for January, "Feb" for February).
    ///
    /// For example:
    /// - If the month is January (represented by 1), it returns "Jan".
    ///     - In Korean, it returns "1월".
    /// - If the month is October (represented by 10), it returns "Oct".
    ///     - In Korean, it returns "10월".
    case MMM
    
    /// Returns the full name of the given month.
    ///
    /// This function converts an integer representing the month into its corresponding
    /// full name (e.g., "January" for 1, "February" for 2).
    ///
    /// For example:
    /// - If the month is January (represented by 1), it returns "January".
    ///     - In Korean, it returns "1월".
    /// - If the month is October (represented by 10), it returns "October".
    ///     - In Korean, it returns "10월".
    case MMMM
}


