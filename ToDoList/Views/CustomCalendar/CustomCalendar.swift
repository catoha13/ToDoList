import SwiftUI

struct CustomCalendar: View {
    @State var currentDate: Date = Date()
    
    @State var days = ["M","T", "W", "T", "F", "S", "S"]
    @State var columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    // update month on swipe
    @State var currentMonth: Int  = 0
    @State var currentWeek: [Date] = []
    @State private var showFullCalendar = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            //MARK: Show/hide calendar button
            Button {
                withAnimation(.default) {
                    showFullCalendar.toggle()
                }
            } label: {
                HStack(alignment: .center, spacing: 6) {
                    Text(getYearAndMonth()[0].uppercased())
                        .font(.RobotoThinItalicExtraSmall)
                        .foregroundColor(.black)
                    
                    Text(getYearAndMonth()[1])
                        .font(.RobotoThinItalicExtraSmall)
                        .foregroundColor(.black)
                    
                    Image(systemName: "chevron.right")
                        .rotationEffect(showFullCalendar ? .degrees(-90) : .degrees(90))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                }
            }
            
            //MARK: Days of the week
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            //MARK: Dates
            LazyVGrid(columns: columns, spacing: 30) {
                if showFullCalendar {
                    //MARK: Month
                    ForEach(extractDate()) { value in
                        CardView(value: value)
                    }
                } else {
                    //MARK: Week
                    ForEach(currentWeek, id: \.self) { value in
                        if isSameDay(firstDate: value, secondDate: Date()) {
                            ZStack {
                                Capsule()
                                    .frame(width: 40, height: 20)
                                    .foregroundColor(.customCoral)
                                    .opacity(0.55)
                                Text(formatDate(date: value))
                                    .font(.RobotoMediumSmall)
                            }
                        }
                        Text(formatDate(date: value))
                            .font(.RobotoMediumSmall)
                    }
                }
            }
            .onChange(of: currentMonth, perform: { _ in
                currentDate = getCurrentMonth()
            })
            
        }
        .onAppear {
            getCurrentWeek()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                if isSameDay(firstDate: value.date, secondDate: Date()) {
                    ZStack {
                        Capsule()
                            .frame(width: 40, height: 20)
                            .foregroundColor(.customCoral)
                            .opacity(0.55)
                        Text("\(value.day)")
                            .font(.RobotoMediumSmall)
                    }
                } else {
                    Text("\(value.day)")
                        .font(.RobotoMediumSmall)
                }
            }
        }
    }
    
    func getCurrentWeek() {
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: currentDate)
        guard let firstWeek = week?.start else { return }
        
        for day in 1..<7 {
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeek) {
                currentWeek.append(weekDay)
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekDay - 2 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month , value: currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
    }
    
    func getYearAndMonth() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func isSameDay(firstDate: Date, secondDate: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(firstDate, inSameDayAs: secondDate)
    }
}

struct CustomCalendar_Previews: PreviewProvider {
    @State static var currentDate = Date()
    static var previews: some View {
        CustomCalendar()
    }
}
