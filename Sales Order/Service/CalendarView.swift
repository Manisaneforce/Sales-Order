//
//  CalendarView.swift
//  Sales Order
//
//  Created by San eforce on 12/02/24.
//

import Foundation
import SwiftUI
import FSCalendar

//struct CalendarView: UIViewRepresentable {
//    @Binding var selectedDate: Date?
//
//    func makeUIView(context: Context) -> FSCalendar {
//        let calendar = FSCalendar()
//        calendar.delegate = context.coordinator
//        return calendar
//    }
//
//    func updateUIView(_ uiView: FSCalendar, context: Context) {
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    class Coordinator: NSObject, FSCalendarDelegate {
//        var parent: CalendarView
//
//        init(parent: CalendarView) {
//            self.parent = parent
//        }
//
//        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//            parent.selectedDate = date
//        }
//    }
//}
