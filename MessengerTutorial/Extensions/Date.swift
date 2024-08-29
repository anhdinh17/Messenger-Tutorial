//
//  Date.swift
//  MessengerTutorial
//
//  Created by Anh Dinh on 8/29/24.
//

import Foundation

extension Date {
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }
    
    // Convert Date to a string of time HH:mm
    private func timeString() -> String {
        return timeFormatter.string(from: self)
    }
    
    // Convert Date to a string of time MM/dd/yy
    private func dayString() -> String {
        return dayFormatter.string(from: self)
    }
    
    func timestampString() -> String {
        // If Date is today
        if Calendar.current.isDateInToday(self) {
            return timeString()
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return dayString()
        }
    }
}
