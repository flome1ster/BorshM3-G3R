//
//  DateHelpers.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 06.06.2022.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}

func convertDateToHourMin(dateValue: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(dateValue))
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "HH:mm"
    let daysBetween = Calendar.current.numberOfDaysBetween(date, and: Date())
    
    if daysBetween == 0 {
        return formatter.string(from: date)
    }
    else if daysBetween == 1 {
        return "Вчера"
    }
    else if daysBetween < 7 {
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    } else{
        formatter.dateFormat = "dd.MM.YYYY"
        return formatter.string(from: date)
    }
    
}

func daysBetween(date: Date) -> Int{

    if #available(iOS 15, *) {
        return Calendar.current.dateComponents([.day], from: date, to: Date.now).day ?? 0
    } else {
      return 0
    }
}


func formatDate(unix: Int) ->String{
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(unix)))
}

func formatDateToPeriod(unix: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(unix))
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ru_RU")
    formatter.dateFormat = "HH:mm"
    let daysBetween = Calendar.current.numberOfDaysBetween(date, and: Date())
    
    if daysBetween == 0 {
       return "Сегодня"
    }
    else if daysBetween == 1 {

        return "Вчера"
    }
    else if daysBetween < 7 {
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: date)
    } else{
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
}
