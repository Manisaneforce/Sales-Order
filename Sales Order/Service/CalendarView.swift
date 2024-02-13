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
            return formatter.date(from: "1900/01/01")!
        }
        
        func maximumDate(for calendar: FSCalendar) -> Date {
//            if (parent.SelMode == "DOT"){
//                return parent.didSelectDate ?? Date()
//            }
            return Date()
         }
    }
}
