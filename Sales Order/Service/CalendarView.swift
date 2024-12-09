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
    @Binding var SelMode: String
    @Binding var SelectFromDate: Date
    @Binding var SelectToDate: Date

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        if SelMode == "DOF" {
            calendar.currentPage = SelectFromDate
            calendar.select(SelectFromDate)
        } else {
            calendar.currentPage = SelectToDate
            calendar.select(SelectToDate)
        }

        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Update the calendar's current page and selected date
        if SelMode == "DOF" {
            if uiView.currentPage != SelectFromDate {
                uiView.setCurrentPage(SelectFromDate, animated: true)
            }
            uiView.select(SelectFromDate)
        } else {
            if uiView.currentPage != SelectToDate {
                uiView.setCurrentPage(SelectToDate, animated: true)
            }
            uiView.select(SelectToDate)
        }
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
            // Update the selected date
            parent.selectedDate = date
        }

        func minimumDate(for calendar: FSCalendar) -> Date {
            // Define the minimum date based on SelMode
            if parent.SelMode == "DOT" {
                return parent.SelectFromDate
            }

            let calendar = Calendar.current
            if let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date()) {
                return oneYearAgo
            }

            return Date()
        }

        func maximumDate(for calendar: FSCalendar) -> Date {
            // Set the maximum date to today
            return Date()
        }

        private func calculateStartDate(for days: Int) -> Date {
            // Helper to calculate a start date
            let calendar = Calendar.current
            if let startDate = calendar.date(byAdding: .day, value: -days, to: Date()) {
                return startDate
            }
            return Date()
        }

        private func formattedDate(date: Date) -> String {
            // Format a date to a string
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    }
}

