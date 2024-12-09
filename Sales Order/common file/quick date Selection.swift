//
//  quick date Selection.swift
//  Sales Order
//
//  Created by Anbu j on 25/11/24.
//

import SwiftUI


protocol DateSelection{
    func didTapButton(in selection: quick_date_Selection_view)
}

struct quick_date_Selection_view:View {
    @Binding var Filterdate:Bool
    @Binding var FromDate:String
    @Binding var SelectFromDate:Date
    @Binding var ToDate:String
    @Binding  var Loader:Bool
    let calendar = Calendar.current
    let currentDate = Date()
   var delegate: DateSelection?
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                Filterdate.toggle()
            }
        VStack{
            ZStack{
                Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 30)
                VStack{
                    Text("Select Quick Dates")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                }
            }
            VStack{
                VStack{
                    Text("Today")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(5)
                }
                .background(Color.white)
                    .onTapGesture{
                        let CurentDate = Date()
                        Loader.toggle()
                        Filterdate.toggle()
                        FromDate = (formattedDate(date: calculateStartDate(for: 1)))
                        GetaData.shared.From = FromDate
                        SelectFromDate = (formattedDates(date: calculateStartDate(for: 1))!)
                        let ToDates = String(dateFormatter.string(from:CurentDate))
                        FromDate = ToDates
                        ToDate = ToDates
                        GetaData.shared.TO = ToDate
                        ButtonTapped()
                    }
                    
                Divider()
                VStack{
                    Text("Yesterday")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(5)
                }
                .background(Color.white)
                    .onTapGesture{
                        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
                        let Getdate = dateFormatter.string(from: yesterdayDate)
                        Loader.toggle()
                        Filterdate.toggle()
                        let formatedate = dateFormatter.date(from: Getdate)
                        FromDate = dateFormatter.string(from:yesterdayDate)
                        GetaData.shared.From = FromDate
                        SelectFromDate = formatedate!
                        let ToDates = Getdate
                        ToDate = ToDates
                        GetaData.shared.TO = ToDate
                        ButtonTapped()
                    }
                    
                Divider()
                
                VStack{
                    Text("Last week")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(5)
                }
                .background(Color.white)
                    .onTapGesture{
                        let CurentDate = Date()
                        Loader.toggle()
                        Filterdate.toggle()
                        FromDate = (formattedDate(date: calculateStartDate(for: 7)))
                        GetaData.shared.From = FromDate
                        SelectFromDate = (formattedDates(date: calculateStartDate(for: 7))!)
                        let ToDates = String(dateFormatter.string(from:CurentDate))
                        ToDate = ToDates
                        GetaData.shared.TO = ToDate
                        ButtonTapped()
                    }
                    
                Divider()
                VStack{
                    Text("Last month")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(5)
                }
                .background(Color.white)
                    .onTapGesture{
                        if let threeMonthsAgo = calendar.date(byAdding: .month, value: -1, to: currentDate) {
                            let numberOfDays = calendar.dateComponents([.day], from: threeMonthsAgo, to:currentDate).day
                            let CurentDate = Date()
                            Loader.toggle()
                            Filterdate.toggle()
                            FromDate = (formattedDate(date: calculateStartDate(for: numberOfDays ?? 0)))
                            GetaData.shared.From = FromDate
                            SelectFromDate = (formattedDates(date: calculateStartDate(for: numberOfDays ?? 0))!)
                            let ToDates = String(dateFormatter.string(from:CurentDate))
                            ToDate = ToDates
                            GetaData.shared.TO = ToDate
                            ButtonTapped()
                        }
                    }
                Divider()
                VStack{
                    Text("Last 3 months")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(5)
                }
                .background(Color.white)
                    .onTapGesture{
                        if let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: currentDate) {
                            let numberOfDays = calendar.dateComponents([.day], from: threeMonthsAgo, to:currentDate).day
                            let CurentDate = Date()
                            Loader.toggle()
                            Filterdate.toggle()
                            FromDate = (formattedDate(date: calculateStartDate(for: numberOfDays ?? 0)))
                            GetaData.shared.From = FromDate
                            SelectFromDate = (formattedDates(date: calculateStartDate(for: numberOfDays ?? 0))!)
                            let ToDates = String(dateFormatter.string(from:CurentDate))
                            ToDate = ToDates
                            GetaData.shared.TO = ToDate
                            ButtonTapped()
                        }
                    }
                Divider()
                VStack{
                    Text("Last 6 months")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(5)
                }
                .background(Color.white)
                .onTapGesture{
                    if let threeMonthsAgo = calendar.date(byAdding: .month, value: -6, to: currentDate) {
                        // Find the difference in days
                    let numberOfDays = calendar.dateComponents([.day], from: threeMonthsAgo, to: currentDate).day
                    
                    let CurentDate = Date()
                    Loader.toggle()
                    Filterdate.toggle()
                    FromDate = (formattedDate(date: calculateStartDate(for: numberOfDays ?? 0)))
                    GetaData.shared.From = FromDate
                    SelectFromDate = (formattedDates(date: calculateStartDate(for: numberOfDays ?? 0))!)
                    let ToDates = String(dateFormatter.string(from:CurentDate))
                    ToDate = ToDates
                    GetaData.shared.TO = ToDate
                    ButtonTapped()
                }
                    }
                Divider()
                VStack{
                    Text("Last 1 year")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(5)
                }
                .background(Color.white)
                .onTapGesture{
                    if let threeMonthsAgo = calendar.date(byAdding: .month, value: -12, to: currentDate) {
                        let numberOfDays = calendar.dateComponents([.day], from: threeMonthsAgo, to: currentDate).day
                    
                        let CurentDate = Date()
                    Loader.toggle()
                    Filterdate.toggle()
                    FromDate = (formattedDate(date: calculateStartDate(for: numberOfDays ?? 0)))
                    GetaData.shared.From = FromDate
                    SelectFromDate = (formattedDates(date: calculateStartDate(for: numberOfDays ?? 0))!)
                    let ToDates = String(dateFormatter.string(from:CurentDate))
                    ToDate = ToDates
                    GetaData.shared.TO = ToDate
                    ButtonTapped()
                        
                }
                    }
            }
            
            ZStack{
                Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 30)
                    .padding(.top,30)
                    .padding(.bottom,10)
                    .padding(.horizontal,15)
                    .cornerRadius(10)
                VStack{
                    Text("Close")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.top,15)
                }
            }.cornerRadius(10)
            .onTapGesture {
                Filterdate.toggle()
            }
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(20)
    }
    
    
    private func ButtonTapped(){
        delegate?.didTapButton(in: self)
    }
    
    private var dateFormatter: DateFormatter {
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          return formatter
      }
    func calculateStartDate(for days: Int) -> Date {
        let startDate = calendar.date(byAdding: .day, value: -days, to: currentDate)
        return startDate ?? currentDate
    }
    func formattedDates(date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDateString = dateFormatter.string(from: date)
        return dateFormatter.date(from: formattedDateString)
    }
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
