import SwiftUI

struct CustomDatePicker: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date?
    @Binding var selectedTime: Date?
    
    @State private var currentDate: Date = Date()
    @State private var currentTime: Date = Date()
    @State private var days = [NSLocalizedString("Mon", comment: ""),
                               NSLocalizedString("Tue", comment: ""),
                               NSLocalizedString("Wed", comment: ""),
                               NSLocalizedString("Thu", comment: ""),
                               NSLocalizedString("Fri", comment: ""),
                               NSLocalizedString("Sat", comment: ""),
                               NSLocalizedString("Sun", comment: "")]
    @State private var columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var currentMonth: Int  = 0
    
    var body: some View {
        ZStack {
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.secondary)
                .onTapGesture {
                    isPresented.toggle()
                }
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
                                .font(.RobotoThinItalicExtraSmall)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    //MARK: Dates
                    ZStack {
                        LazyVGrid(columns: columns, spacing: 16) {
                            //MARK: Month
                            ForEach(extractDate()) { value in
                                CardView(value: value)
                            }
                        }
                        .frame(height: 230)
                        .padding(.bottom, 20)
                        .onChange(of: currentMonth, perform: { _ in
                            withAnimation {
                                currentDate = getCurrentMonth()
                            }
                        })
                    }
                    DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
                        .padding(.trailing, 140)
                        .padding(.bottom)
                    
                    CustomCoralFilledButtonSmall(text: "Done") {
                        withAnimation {
                            isPresented.toggle()
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(.white)
            .cornerRadius(Constants.radiusFive)
            .shadow(radius: 5)
            .padding(.horizontal, 20)
            .frame(height: 340)
            .animation(.default, value: selectedDate)
        }
    }
    
    func CardView(value: DateValue) -> some View {
        ZStack {
            //MARK: Selected Day
            if value.day != -1 {
                if isSameDay(firstDate: value.date, secondDate: selectedDate ?? Date()) {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.customBlue)
                        .opacity(0.45)
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
                                .padding(.vertical, 4)
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
    @State static var selectedTime: Date? = Date()
    @State static var isPresented = false
    static var previews: some View {
        CustomDatePicker(isPresented: $isPresented, selectedDate: $selectedDate, selectedTime: $selectedTime)
    }
}
