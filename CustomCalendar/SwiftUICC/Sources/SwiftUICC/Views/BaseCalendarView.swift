//
//  BaseCalendarView.swift
//  SwiftUICC
//
//  Created by woong on 1/31/25.
//

//    TODO: month만 쓸지 고려하기

// TODO: 셀 크기 외부에서 받을 수 있도록 하기


// 추가로 deselect 되게끔 할건지 그런것도 확인하기.

// TODO: 전후로 날짜들 보여주기

import SwiftUI

public struct BaseCalendarView: View {
    let calendar = Calendar.current
    
    @State var month: Date
    private var headerType: HeaderType
    private var monthType: MonthType
    private var isShowOtherDays: Bool
    
    @State var clickedDays: Set<Date> = []
    
    init(month: Date,
         headerType: HeaderType = .month,
         monthType: MonthType = .MM,
         isShowOtherDays: Bool = false) {
        self.month = month
        self.headerType = headerType
        self.monthType = monthType
        self.isShowOtherDays = isShowOtherDays
        
        changeMonthType(for: monthType)
    }
    
    public var body: some View {
        VStack {
            header
            grid
        }
    }
    
//    TODO: .month만 쓸지 고려하기
    private var header: some View {
        HStack(alignment: .center) {
            switch headerType {
            case .yearMonth:
                Text("\(month)")
                    .font(.title2)
                    .fontWeight(.bold)
            case .month:
                HStack {
                    Button {
                        withAnimation(nil) {
                            changeMonth(by: -1)
                        }
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title)
                    }
                    
                    Text(month, formatter: Self.dateFormatter)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Button {
                        withAnimation(nil) {
                            changeMonth(by: 1)
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title)
                    }
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
                ForEach(0..<totalItems, id: \.self) { index in
                    let dayNum = index + 2 - getFirstDayOfMonthInt(date: month)
                    let constForclickedDaycheck:Date = getDate(for: dayNum)
                    let isClicked = clickedDays.contains(constForclickedDaycheck)
                    
//                    TODO: 전후 날짜의 deselect 여부도 생각하기.
                    let lastDayNum = Int(getLastDay().toString(format: "dd"))!
                    
//                    isShowOtherDays에 따라 이전/이후 날짜 보여줌
                    if isShowOtherDays { // 보여줌
                        if dayNum < 1 || dayNum > lastDayNum {
                            let dayNumber = calculateDateNum(for: dayNum)
                            DateCell(day: dayNumber, clicked: isClicked, isShowOtherDays: true, dayColor: .deactivate)
                        } else {
                            let dayNumber = calculateDateNum(for: dayNum)
                            
                            DateCell(day: dayNumber, clicked: isClicked, isShowOtherDays: true, dayColor: .normal)
                                .onTapGesture {
                                    if isClicked {
                                        clickedDays.remove(constForclickedDaycheck)
                                    } else {
                                        clickedDays.insert(constForclickedDaycheck)
                                    }
                                }
//                                TODO: 셀 크기 외부에서 받을 수 있도록 하기
                                .frame(height: 80)
                        }
                        
                            
                    } else { // 안보여줌
                        if dayNum < 1 || dayNum > lastDayNum {
                            Rectangle()
                                .foregroundStyle(.clear)
                        } else {
                            DateCell(day: dayNum, clicked: isClicked, isShowOtherDays: false)
                                .frame(height: 80)
                                .onTapGesture {
                                    if isClicked {
                                        clickedDays.remove(constForclickedDaycheck)
                                    } else {
                                        clickedDays.insert(constForclickedDaycheck)
                                    }
                                }
//                            TODO: 셀 크기 외부에서 받을 수 있도록 하기
                                
                        }
                    }
                }
            }
        }
    }
}

private struct DateCell: View {
    private var day: Int
    private var clicked: Bool = false
    private var showOtherDays: Bool
    private var dayColor: DayColorType
    
    private var textColor = Color.yellow
    
    init(day: Int,
         clicked: Bool,
         isShowOtherDays: Bool = false,
         dayColor: DayColorType = .normal) {
        self.day = day
        self.clicked = clicked
        self.showOtherDays = isShowOtherDays
        self.dayColor = dayColor
        
        switch dayColor {
        case .normal:
            textColor = Color.black
        case .deactivate:
            textColor = .gray
        case .satBlue:
            textColor = .blue
        case .holiday:
            textColor = .red
        }
    }
    
    var body: some View {
        VStack {
            if showOtherDays {
                Text("\(day)")
                    .foregroundStyle(textColor)
//                    .padding(.bottom)
                
//                TODO: multi or single selection 선택하기
//                TODO: 가능하다면 시작일 끝나는일 선택 하면 연달아서 선택할 수 있도록(반환하는 함수에서 시작일, 종료일에 대한 연속적인 Date변수 넘겨주기)
                if clicked {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(width: 10, height: 10)
                }
                
            } else {
                Text("\(day)")
//                    .padding(.bottom)
                if clicked {
                    Circle()
                        .foregroundStyle(.red)
                        .frame(width: 10, height: 10)
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
    
    /// 현재 달 마지막 날 Date로 반환
    func getLastDay() -> Date {
        let dateComp = Calendar.current.dateComponents([.year, .month], from: month)
        var tempDate = calendar.date(from: dateComp)
        tempDate = calendar.date(byAdding: .month, value: 1, to: tempDate!)
        return calendar.date(byAdding: .day, value: -1, to: tempDate!)!
    }
    
    /// 특정일 Int -> Date로 반환
    func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: getFirstDayOfMonthDate(date: month))!
    }
    
    /// 특정일 Int -> Int로 변환
    func calculateDateNum(for day: Int) -> Int {
        var result = day
        var day = day
        
        if day < 1 {
            day -= 1
            let temp = Calendar.current.date(byAdding: .day, value: day, to: getFirstDayOfMonthDate(date: month))
            result = Int((temp?.toString(format: "dd"))!)!
        }
        
        let lastDayInt = Int(getLastDay().toString(format: "dd"))!
        
        if day > lastDayInt { // 여기에 31이 아니라 month 의 마지막날보다 큰 지 체크
            result = day - lastDayInt
        }
        
        return result
    }
}

extension BaseCalendarView {
//    TODO: private extension으로 옮겨놓기
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
    
    BaseCalendarView(month: month, isShowOtherDays: false)
}
