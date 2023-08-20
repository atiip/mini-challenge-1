//
//  DateExtension.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 06/08/23.
//

import SwiftUI

extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var tomorrow: Date {
           var components = DateComponents()
           components.day = 1
           return Calendar.current.date(byAdding: components, to: Date()) ?? Date()
       }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    func dateString(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
    
    
    func convertDate(date: Date) -> Date {
        let calender = Calendar.current
        let startOfDay = calender.startOfDay(for: date)
        return startOfDay
    }
   
}
