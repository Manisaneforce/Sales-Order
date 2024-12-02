//
//  CalendarView.swift
//  Sales Order
//
//  Created by San eforce on 12/02/24.
//

import Foundation
import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    @Binding var selectedDate: Date
    @State private var didSelectDate: Date?
    @Binding var SelMode: String
    @Binding var SelectFromDate: Date
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView

        init(parent: CalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            print(date)
          //  parent.didSelectDate = parent.SelectFromDate
            
        }

        func minimumDate(for calendar: FSCalendar) -> Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            if (parent.SelMode == "DOT"){
                return parent.SelectFromDate
            }
            let calendar = Calendar.current
            let currentDate = Date()
            var Getdate:String = ""
            if let threeMonthsAgo = calendar.date(byAdding: .month, value: -12, to: currentDate) {
                let numberOfDays = calendar.dateComponents([.day], from: threeMonthsAgo, to: currentDate).day
               let OneyerDate = (formattedDate(date: calculateStartDate(for: numberOfDays ?? 0)))
                Getdate = OneyerDate
            }
            return formatter.date(from: Getdate)!
        }
        
        func maximumDate(for calendar: FSCalendar) -> Date {
//            if (parent.SelMode == "DOT"){
//                return parent.didSelectDate ?? Date()
//            }
            return Date()
         }
        
        func calculateStartDate(for days: Int) -> Date {
            let calendar = Calendar.current
            let currentDate = Date()
            let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
            return startDate ?? currentDate
        }
        
        func formattedDate(date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
    }
}
