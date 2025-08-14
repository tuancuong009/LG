import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    @Binding var currentMonthOffset: Int
    var markedDates: [LocationObj]
    var onDateSelected: ((Date) -> Void)? = nil

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var body: some View {
        VStack {
            // Header days
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.appFontRegular(12))
                        .foregroundColor(.white50)
                }
            }

            let daysInMonth = generateDates()

            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(daysInMonth, id: \.self) { date in
                    if date != Date.distantPast && date != Date.distantFuture {
                        let day = Calendar.current.component(.day, from: date)
                        let isCurrentMonth = Calendar.current.isDate(date, equalTo: dateFromOffset(), toGranularity: .month)
                        let isFuture = Calendar.current.startOfDay(for: date) > Calendar.current.startOfDay(for: Date())
                        let currentDateStr = getCurrentDateString(date: date)

                        VStack(spacing: 5) {
                            Text("\(day)")
                                .font(.appFontMedium(15))
                                .foregroundColor(
                                    isFuture ? Color.gray.opacity(0.5) : .white
                                )
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle()
                                        .fill(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.white10 : Color.clear)
                                )

                            if markedDates.contains(where: { $0.date_calendar == currentDateStr }) {
                                Circle()
                                    .fill(Color.purple)
                                    .frame(width: 5, height: 5)
                            }
                        }
                        .onTapGesture {
                            guard !isFuture else { return }
                            selectedDate = date
                            onDateSelected?(date)
                        }
                    } else {
                        Text("") // Ô trống cho padding
                            .frame(width: 36, height: 36)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers
    func dateFromOffset() -> Date {
        Calendar.current.date(byAdding: .month, value: currentMonthOffset, to: Date())!
    }

    func generateDates() -> [Date] {
        let calendar = Calendar(identifier: .gregorian)
        let current = dateFromOffset()

        var components = calendar.dateComponents([.year, .month], from: current)
        components.day = 1
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return [] }

        let firstWeekday = (calendar.component(.weekday, from: startOfMonth) + 5) % 7 // Monday = 0
        var dates: [Date] = []

        // Ngày tháng trước
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth),
           let prevRange = calendar.range(of: .day, in: .month, for: prevMonth) {
            let prevMonthDays = prevRange.count
            for day in (prevMonthDays - firstWeekday + 1)...prevMonthDays {
                var prevComp = calendar.dateComponents([.year, .month], from: prevMonth)
                prevComp.day = day
                if let date = calendar.date(from: prevComp) {
                    dates.append(date)
                }
            }
        }

        // Ngày tháng hiện tại
        for day in range {
            components.day = day
            if let date = calendar.date(from: components) {
                dates.append(date)
            }
        }

        // Ngày tháng sau
        let remaining = 42 - dates.count
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) {
            var nextComp = calendar.dateComponents([.year, .month], from: nextMonth)
            for day in 1...remaining {
                nextComp.day = day
                if let date = calendar.date(from: nextComp) {
                    dates.append(date)
                }
            }
        }

        return dates
    }

    func getCurrentDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
}
