import SwiftUI

struct CustomDatePicker: View {
    @State var currentDate: Date = Date()
    @Binding var selectedDate: Date?
    
    @State var days = ["M","T", "W", "T", "F", "S", "S"]
    @State var columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State var currentMonth: Int  = 0
    
    var body: some View {
        ZStack {
            SwipeGesture(selector: $currentMonth)
            VStack(spacing: 20) {
                //MARK: Month and Year
                HStack(alignment: .center, spacing: 6) {
                    Text(getYearAndMonth()[0].uppercased())
                        .font(.RobotoThinItalicExtraSmall)
                        .foregroundColor(.black)
                    
                    Text(getYearAndMonth()[1])
                        .font(.RobotoThinItalicExtraSmall)
                        .foregroundColor(.black)
                }
                .padding(.top, 20)
                
                //MARK: Days of the week
                HStack(spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                //MARK: Dates
                ZStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        //MARK: Month
                        ForEach(extractDate()) { value in
                            CardView(value: value)
                        }
                    }
                    .padding(.bottom)
                    .onChange(of: currentMonth, perform: { _ in
                        withAnimation {
                            currentDate = getCurrentMonth()
                        }
                    })
                }
            }
        }
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .shadow(radius: 5)
            .padding(.horizontal, 40)
            .padding(.bottom, 340)
        .animation(.spring(), value: selectedDate)
        
    }
    
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
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 9)
                                
                            }
                        }
                    } else {
                        Button {
                            selectedDate = value.date
                        } label: {
                            Text("\(value.day)")
                                .font(.RobotoMediumSmall)
                                .foregroundColor(.black)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 9)
                        }
                    }
                }
            }
        }
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

struct CustomDatePicker_Previews: PreviewProvider {
    @State static var selectedDate: Date? = Date()
    static var previews: some View {
        CustomDatePicker(selectedDate: $selectedDate)
    }
}
