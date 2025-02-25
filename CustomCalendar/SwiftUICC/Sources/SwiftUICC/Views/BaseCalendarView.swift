//
//  BaseCalendarView.swift
//  SwiftUICC
//
//  Created by woong on 1/31/25.
//

import SwiftUI

public struct BaseCalendarView: View {
    @State var month: Date
    
    var headerType: HeaderType?
    var monthType: MonthType?
    
    @State var clickedDays: Set<Date> = []
    
    private var tempMonth: String = Date().toString(format: "M")
    private var displayMonth: String {
        set {
            tempMonth = newValue
        }
        
        get {
            return tempMonth
        }
    }
    
    init(month: Date, headerType: HeaderType? = .month, monthType: MonthType? = .MM) {
        self.month = month
        self.headerType = headerType
        self.monthType = monthType
        
        guard let mt = monthType else { return }
        changeMonthType(for: mt)
    }
    
//    init(month: Date, headerType: HeaderType? = .month) {
//        self.month = month
//        self.headerType = headerType
//    }
    
    public var body: some View {
        VStack {
            header
            grid
        }
    }
    
//    TODO: month만 쓸지 고려하기
    private var header: some View {
        HStack(alignment: .center) {
            switch headerType {
            case .yearMonth:
                Text("\(displayMonth)")
                    .font(.title2)
                    .fontWeight(.bold)
            case .month:
                HStack {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                    }
                    
                    Text(month, formatter: Self.dateFormatter)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title)
                    }
                }
            case nil:
                VStack {
                    Text("\(displayMonth)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    private var grid: some View {
        let columns: [GridItem] = Array(repeating: GridItem(), count: 7)
        let daysNum = daysInMonth(date: month) + getFirstDayOfMonthInt(date: month)
        var rows: Int {
            if daysNum % 7 > 0 {
                return daysNum / 7 + 1
            } else {
                return daysNum / 7
            }
        }
        let totalItems = rows * 7
        
        return VStack {
            LazyVGrid(columns: columns) {
                
                let _ = print("----------------------------")
                let _ = print("🏠Month:",month)
                let _ = print("daysInMonth:",daysInMonth(date: month))
                let _ = print("firstDayOfMonth:",getFirstDayOfMonthInt(date: month))
                let _ = print("rows:",rows)
                let _ = print("----------------------------")
                
                ForEach(0..<totalItems, id: \.self) { num in
                    let dayNum = num + 2 - getFirstDayOfMonthInt(date: month)
                    let constForclickedDaycheck:Date = getDate(for: dayNum)
                    let isClicked = clickedDays.contains(constForclickedDaycheck)
                    
                    DateCell(day: dayNum, clicked: isClicked)
                        .onTapGesture {
                            if isClicked {
                                clickedDays.remove(constForclickedDaycheck)
                            } else {
                                clickedDays.insert(constForclickedDaycheck)
                            }
                        }
                }
            }
        }
    }
}

private struct DateCell: View {
    var day: Int
    var clicked: Bool = false
    var showOtherDays: Bool = false
    
    init(day: Int, clicked: Bool) {
        self.day = day
        self.clicked = clicked
    }
    
    var body: some View {
        VStack {
            if showOtherDays {
                
//                TODO: 전후로 날짜들 보여주기
                
                Text("\(day)")
    //            TODO: 여기도 커스텀 가능하도록
                if clicked {
                    Circle()
                        .foregroundStyle(.red)
                }
                
            } else {
                Text("\(day)")
    //            TODO: 여기도 커스텀 가능하도록
                if clicked {
                    Circle()
                        .foregroundStyle(.red)
                }
            }
            
        }
    }
}

private extension BaseCalendarView {
    /// 특정 해당 날짜
//    func getDate(for day: Int) -> Date {
//        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
//    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
    
}

// MARK: private extensions for BaseCalendarView(내가 만든거)

private extension BaseCalendarView {
    /// Returns the total number of days in the month of the given date.
    ///
    /// This function uses the current `Calendar` to calculate the range of days in the month
    /// that contains the provided date and returns the count of those days.
    /// If the calculation fails, it returns 0.
    ///
    /// - Parameter date: The reference date for which to calculate the number of days in its month.
    /// - Returns: The total number of days in the month (returns 0 if the calculation fails).
    func daysInMonth(date: Date) -> Int {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else { return 0 }
        return range.count
    }
    
    /// 현재 달 첫번째 날 Date로 반환
    func getFirstDayOfMonthDate(date: Date) -> Date {
        let dateComp = Calendar.current.dateComponents([.year, .month], from: date)
        return Calendar.current.date(from: dateComp)!
    }
    
    /// 현재 달 첫번째 날 Int로 반환
    func getFirstDayOfMonthInt(date: Date) -> Int {
        let firstDay = getFirstDayOfMonthDate(date: date)
        return Calendar.current.component(.weekday, from: firstDay)
    }
    
    /// 특정일 Int -> Date로 반환
    func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: getFirstDayOfMonthDate(date: month))!
    }
    
    /// 특정일 Int -> Int로 변환
    func calculateDateNum(for day: Int) -> Int {
        let result = 0
        
        if day < 1 {
            
        }
        
        if day < 31 { // 여기에 31이 아니라 month 의 마지막날보다 큰 지 체크
            
        }
        
        return 1
    }
}

extension BaseCalendarView {
    func changeMonthType(for mt: MonthType) {
        switch mt {
        case .M:
            BaseCalendarView.dateFormatter.dateFormat = "M"
        case .MM:
            BaseCalendarView.dateFormatter.dateFormat = "MM"
        case .MMM:
            BaseCalendarView.dateFormatter.dateFormat = "MMM"
        case .MMMM:
            BaseCalendarView.dateFormatter.dateFormat = "MMMM"
        }
    }
    
    func setMonthType(to mt: MonthType) -> BaseCalendarView {
        let copy = self
        self.changeMonthType(for: mt)
        return copy
    }
}


extension BaseCalendarView {
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
}

#Preview("iOS") {
    @Previewable @State var month = Date()
    
    BaseCalendarView(month: month)
}
