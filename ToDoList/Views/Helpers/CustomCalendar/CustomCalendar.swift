import SwiftUI

struct CustomCalendar: View {
    @Binding var selectedDate: Date?
    
    @State private var currentDate: Date = Date()
    
    @State private var days = [NSLocalizedString("Mon", comment: ""),
                               NSLocalizedString("Tue", comment: ""),
                               NSLocalizedString("Wed", comment: ""),
                               NSLocalizedString("Thu", comment: ""),
                               NSLocalizedString("Fri", comment: ""),
                               NSLocalizedString("Sat", comment: ""),
                               NSLocalizedString("Sun", comment: "")]
    @State private var columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State private var currentMonth: Int  = 0
    @State private var currentWeek: [Date] = []
    @State private var showFullCalendar = false
    
    var body: some View {
        ZStack {
            if showFullCalendar {
                SwipeGesture(selector: $currentMonth)
            }
            VStack(spacing: 10) {
                
                //MARK: Show/hide calendar button
                Button {
                    withAnimation(.easeIn) {
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
                LazyVGrid(columns: columns, spacing: 20) {
                    if showFullCalendar {
                        //MARK: Month
                        ForEach(extractDate()) { value in
                            CardView(value: value)
                        }
                    } else {
                        //MARK: Week
                        ForEach(currentWeek, id: \.self) { value in
                            ZStack {
                                if isSameDay(firstDate: value, secondDate: Date()) {
                                    ZStack {
                                        Text(formatWeekDate(date: value))
                                            .font(.RobotoMediumSmall)
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.customBlue)
                                            .opacity(0.35)
                                    }
                                }
                                Text(formatWeekDate(date: value))
                                    .font(.RobotoMediumSmall)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                
                .onChange(of: currentMonth, perform: { _ in
                    currentDate = getCurrentMonth()
                })
            }
            .onAppear {
                getCurrentWeek()
            }
        }
        .animation(.easeIn, value: currentMonth)
        .animation(.easeIn, value: currentDate)
        .background(.white)
        .cornerRadius(0)
        .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 3)
        .padding(.vertical, 10)
    }
    
    func CardView(value: DateValue) -> some View {
        ZStack {
            //MARK: Selected Day
            if value.day != -1 {
                if isSameDay(firstDate: value.date, secondDate: selectedDate ?? Date()) {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.customBlue)
                        .opacity(0.35)
                }
            }
            //MARK: Regular
            VStack {
                if value.day != -1 {
                    if isSameDay(firstDate: value.date, secondDate: Date()) {
                        ZStack {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.customBlue)
                            Button {
                                selectedDate = value.date
                            } label: {
                                Text("\(value.day)")
                                    .font(.RobotoMediumSmall)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 12)
                            }
                        }
                    } else {
                        Button {
                            selectedDate = value.date
                        } label: {
                            Text("\(value.day)")
                                .font(.RobotoMediumSmall)
                                .foregroundColor(.black)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                        }
                        
                    }
                }
            }
        }
    }
    
    func getCurrentWeek() {
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: currentDate)
        guard let firstWeek = week?.start else { return }
        
        for day in 1...7  {
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstWeek) {
                currentWeek.append(weekDay)
            }
        }
    }
    
    func formatWeekDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
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
        for _ in 0..<firstWeekDay + 5 {
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
    @State static var selectedDate: Date? = Date()
    static var previews: some View {
        CustomCalendar(selectedDate: $selectedDate)
    }
}
