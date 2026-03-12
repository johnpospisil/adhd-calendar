import SwiftUI

struct MonthView: View {
    @Bindable var viewModel: CalendarViewModel
    @State private var selectedDayForSheet: CalendarDay?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekdayHeaders = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                monthNavigationHeader
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                // Weekday column headers
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(weekdayHeaders, id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                }
                .padding(.horizontal, 4)

                Divider()

                // Day grid
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(leadingEmptyCells, id: \.self) { _ in
                        Color.clear.frame(height: 52)
                    }
                    ForEach(viewModel.calendarDays(for: viewModel.currentMonth)) { day in
                        DayCell(day: day, isSelected: day.date.isSameDay(as: viewModel.selectedDate))
                            .onTapGesture {
                                viewModel.selectDate(day.date)
                                selectedDayForSheet = day
                            }
                    }
                }
                .padding(.horizontal, 4)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .task { await viewModel.loadEvents() }
            .sheet(item: $selectedDayForSheet) { day in
                DayView(viewModel: viewModel, date: day.date)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private var monthNavigationHeader: some View {
        HStack {
            Button {
                viewModel.navigateMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.medium)
            }

            Spacer()

            Text(viewModel.currentMonth.monthYearString)
                .font(.title2)
                .fontWeight(.semibold)

            Spacer()

            Button {
                viewModel.navigateMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .fontWeight(.medium)
            }
        }
        .padding(.top, 8)
    }

    private var leadingEmptyCells: [Int] {
        guard let firstDay = Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: viewModel.currentMonth)
        ) else { return [] }
        let weekday = Calendar.current.component(.weekday, from: firstDay)
        return Array(0..<(weekday - 1))
    }
}

// MARK: – Day cell

private struct DayCell: View {
    let day: CalendarDay
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 3) {
            Text(day.date.dayNumber)
                .font(.callout)
                .fontWeight(day.date.isToday ? .bold : .regular)
                .foregroundStyle(cellTextColor)
                .frame(width: 30, height: 30)
                .background {
                    if isSelected {
                        Circle().fill(Color.accentColor)
                    } else if day.date.isToday {
                        Circle().fill(Color.accentColor.opacity(0.15))
                    }
                }

            // Event dots
            HStack(spacing: 2) {
                ForEach(day.events.prefix(3)) { event in
                    Circle()
                        .fill(event.category.color)
                        .frame(width: 5, height: 5)
                }
            }
            .frame(height: 6)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .contentShape(Rectangle())
    }

    private var cellTextColor: Color {
        if isSelected { return .white }
        if day.date.isToday { return .accentColor }
        return .primary
    }
}

#Preview {
    MonthView(viewModel: CalendarViewModel())
}
