//
//  Date+Extension.swift
//  BankAssistant
//
//  Created by SuperT on 14/07/2022.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yyyy") -> String {
        let format = DateFormatter().apply {
            $0.dateFormat = format
            $0.timeZone = .current
        }
        return format.string(from: self)
    }
    
    func isSameDay(_ date: Date) -> Bool {
        return self.toString() == date.toString()
    }
    
    func isToday() -> Bool {
        return isSameDay(Date())
    }
    
    func isYesterDay() -> Bool {
        return Date().dateByAddingDay(-1).isSameDay(self)
    }
    
    func monthByAdding(value: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: value, to: self)
    }
}

private extension Date {
    func dateByAddingDay(_ day: Int, calendarId: Calendar.Identifier = .gregorian) -> Date {
        let calendar = Calendar(identifier: calendarId)
        return calendar.date(byAdding: .day, value: day, to: self)!
    }
}
