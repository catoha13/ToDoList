import SwiftUI

struct CustomCalendar: View {
    @Binding var selectedDate: Date?
    
    @State var currentDate: Date = Date()
    
    @State var days = ["M","T", "W", "T", "F", "S", "S"]
    @State var columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @State var currentMonth: Int  = 0
    @State var currentWeek: [Date] = []
    @State private var showFullCalendar = false
    
    var body: some View {
        ZStack {
            if showFullCalendar {
                SwipeGesture(selector: $currentMonth)
            }
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
                .animation(.default, value: currentMonth)
                .onChange(of: currentMonth, perform: { _ in
                    withAnimation(.default) {
                        currentDate = getCurrentMonth()
                    }
                })
            }
            .onAppear {
                getCurrentWeek()
            }
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        ZStack {
            //MARK: Selected Day
            if value.day != -1 {
                if isSameDay(firstDate: value.date, secondDate: selectedDate ?? Date()) {
                    Capsule()
                        .frame(width: 40, height: 20)
                        .foregroundColor(.customCoral)
                        .opacity(0.35)
                }
            }
            //MARK: Regular
            VStack {
                if value.day != -1 {
                    if isSameDay(firstDate: value.date, secondDate: Date()) {
                        ZStack {
                            Capsule()
                                .frame(width: 40, height: 20)
                                .foregroundColor(.customCoral)
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
        
        for day in 0..<6 {
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
        for _ in 0..<firstWeekDay - 1 {
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
