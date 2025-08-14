import SwiftUI

struct CalendarView: View {
    @State private var path: [AppRoute] = []
    @State private var selectedDate = Date()
    @State private var currentMonthOffset = 0
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var vm = LocationViewModel()
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("bgAll2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    calendarHeader

                    CalendarGridView(
                        selectedDate: $selectedDate,
                        currentMonthOffset: $currentMonthOffset,
                        markedDates: vm.itemAlls) { date in
                            selectedDate = date
                            vm.load(for: self.getCurrentDateString())
                        }

                    eventList
                }
                .padding(.top, safeAreaInsets.top)
                .ignoresSafeArea(.keyboard)
            }
            .onAppear {
                vm.loadAll()
                vm.load(for: self.getCurrentDateString())
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .detailLocation(let event):
                    DetailLocationView(path: $path, event: event)

                case .otherPage:
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
    private var calendarHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Calendar")
                    .font(.appFontSemibold(32))
                    .foregroundColor(.white)

                HStack(spacing: 1) {
                    Text(monthYearText())
                        .font(.appFontMedium(15))
                        .foregroundColor(.yellow)

                    Text(yearText())
                        .font(.appFontMedium(15))
                        .foregroundColor(.white)
                }
            }
            Spacer()

            HStack(spacing: 10) {
                Button(action: {
                    currentMonthOffset -= 1
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "arrow.left").foregroundColor(.white)
                        )
                }

                Button(action: {
                    currentMonthOffset += 1
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "arrow.right").foregroundColor(.white)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    private var eventList: some View {
        VStack {
            if vm.items.isEmpty {
                
                VStack(spacing: 10) {
                    Image("empty_caledar")
                    Text("Nothing here yet")
                        .font(.appFontRegular(15))
                        .foregroundColor(.white50)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach($vm.items, id: \.id) { $item in
                            EventRow(onBookmark: { event in
                               
                            }, onDetail: { event in
                                path.append(.detailLocation(event))
                            }, event: $item)
                            DashedHorizontalLine()
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding()
                    .padding(.bottom, safeAreaInsets.bottom + 120)
                }
                .background(Color.clear)
            }
        }
        .partialBorder(
            color: .white15,
            width: 1,
            edges: [.top, .leading, .trailing],
            corners: [.topLeft, .topRight],
            cornerRadius: 20
        )
        .padding(.bottom, -50)
    }

    func monthYearText() -> String {
        let calendar = Calendar.current
        let currentDate = calendar.date(byAdding: .month, value: currentMonthOffset, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: currentDate)
    }

    func yearText() -> String {
        let calendar = Calendar.current
        let currentDate = calendar.date(byAdding: .month, value: currentMonthOffset, to: Date()) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: currentDate)
    }
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: selectedDate)
    }
}
