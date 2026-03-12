import SwiftUI

struct DayView: View {
    @Bindable var viewModel: CalendarViewModel
    var date: Date?

    @State private var selectedEvent: CalendarEvent?
    @State private var scrollProxy: ScrollViewProxy?

    private var displayDate: Date { date ?? viewModel.selectedDate }
    private var dayEvents: [CalendarEvent] { viewModel.eventsForDate(displayDate) }
    private let hourHeight: CGFloat = 60

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Week strip for navigation
                let weekDates = weekDatesAround(displayDate)
                WeekStripView(selectedDate: Binding(
                    get: { viewModel.selectedDate },
                    set: { viewModel.selectDate($0) }
                ), weekDates: weekDates)

                Divider()

                if dayEvents.isEmpty {
                    emptyStateView
                } else {
                    timelineView
                }
            }
            .navigationTitle(displayDate.dayString)
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.loadEvents() }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event, calendarViewModel: viewModel)
            }
        }
    }

    // MARK: – Timeline

    private var timelineView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    // Hour rows
                    VStack(spacing: 0) {
                        ForEach(0..<24, id: \.self) { hour in
                            HStack(alignment: .top, spacing: 8) {
                                Text(hourLabel(hour))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 44, alignment: .trailing)

                                Divider()
                            }
                            .frame(height: hourHeight)
                            .id("hour-\(hour)")
                        }
                    }

                    // Current time indicator
                    if displayDate.isToday {
                        currentTimeIndicator
                    }

                    // Event blocks
                    ForEach(dayEvents) { event in
                        if !event.isAllDay {
                            eventBlock(for: event)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .onAppear {
                let hour = Calendar.current.component(.hour, from: Date())
                let scrollHour = max(0, hour - 1)
                proxy.scrollTo("hour-\(scrollHour)", anchor: .top)
            }
        }
    }

    private func eventBlock(for event: CalendarEvent) -> some View {
        let topOffset = offsetForDate(event.startDate)
        let blockHeight = heightForDuration(from: event.startDate, to: event.endDate)

        return TimeBlockView(event: event) {
            selectedEvent = event
        }
        .frame(height: max(blockHeight, 30))
        .padding(.leading, 56)
        .padding(.trailing, 8)
        .offset(y: topOffset)
    }

    private var currentTimeIndicator: some View {
        let offset = offsetForDate(Date())
        return HStack(spacing: 0) {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .padding(.leading, 48)
            Rectangle()
                .fill(Color.red)
                .frame(height: 1)
        }
        .offset(y: offset)
    }

    // MARK: – Empty state

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.checkmark")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No events today")
                .font(.title3)
                .fontWeight(.medium)
            Text("Enjoy the open time — you've earned it.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: – Helpers

    private func offsetForDate(_ date: Date) -> CGFloat {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let totalMinutes = CGFloat((components.hour ?? 0) * 60 + (components.minute ?? 0))
        return totalMinutes * (hourHeight / 60)
    }

    private func heightForDuration(from start: Date, to end: Date) -> CGFloat {
        let minutes = max(end.timeIntervalSince(start) / 60, 30)
        return CGFloat(minutes) * (hourHeight / 60)
    }

    private func hourLabel(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        var components = DateComponents()
        components.hour = hour
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? Date()
        return formatter.string(from: date)
    }

    private func weekDatesAround(_ date: Date) -> [Date] {
        let cal = Calendar.current
        let weekday = cal.component(.weekday, from: date)
        let startOffset = -(weekday - 1)
        return (0..<7).compactMap { cal.date(byAdding: .day, value: startOffset + $0, to: date) }
    }
}

#Preview {
    DayView(viewModel: CalendarViewModel())
}
