//
//  DateFormatHelper.swift
//  Services
//
//  Created by Uday Kumar Kotla on 06/01/26.
//


import Foundation

func formatServiceDate(from isoString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    let date: Date
    if let d = isoFormatter.date(from: isoString) {
        date = d
    } else if let d = ISO8601DateFormatter().date(from: isoString) {
        date = d
    } else {
        return isoString
    }
    
    let calendar = Calendar.current
    
    if calendar.isDateInToday(date) {
        return "Today, \(formatTime(date))"
    } else if calendar.isDateInTomorrow(date) {
        return "Tomorrow, \(formatTime(date))"
    } else if calendar.isDateInYesterday(date) {
        return "Yesterday, \(formatTime(date))"
    } else {
        return "\(formatDate(date)), \(formatTime(date))"
    }
}

private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    return formatter.string(from: date)
}

private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    return formatter.string(from: date)
}

