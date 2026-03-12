import Foundation
import Observation

@Observable
class CalendarViewModel {
    var selectedDate: Date = Date()
    var currentMonth: Date = Date()
    var events: [CalendarEvent] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let eventKitService: EventKitService

    init(eventKitService: EventKitService = EventKitService()) {
        self.eventKitService = eventKitService
    }

    // MARK: – Data loading

    func loadEvents() async {
        await MainActor.run { isLoading = true }

        if eventKitService.authorizationStatus != .fullAccess {
            do {
                try await eventKitService.requestAccess()
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
                return
            }
        }

        let start = currentMonth.startOfMonth
        let end = currentMonth.endOfMonth
        let fetched = eventKitService.fetchEvents(from: start, to: end)

        await MainActor.run {
            events = fetched
            isLoading = false
            errorMessage = nil
        }
    }

    // MARK: – Navigation

    func selectDate(_ date: Date) {
        selectedDate = date
    }

    func navigateMonth(by offset: Int) {
        guard let newMonth = Calendar.current.date(
            byAdding: .month,
            value: offset,
            to: currentMonth
        ) else { return }

        currentMonth = newMonth
        Task { await loadEvents() }
    }

    // MARK: – Queries

    func eventsForDate(_ date: Date) -> [CalendarEvent] {
        events.filter { event in
            Calendar.current.isDate(event.startDate, inSameDayAs: date)
        }
        .sorted { $0.startDate < $1.startDate }
    }

    func calendarDays(for month: Date) -> [CalendarDay] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: month),
              let firstDay = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: month))
        else { return [] }

        return range.compactMap { dayOffset -> CalendarDay? in
            guard let date = Calendar.current.date(byAdding: .day, value: dayOffset - 1, to: firstDay) else {
                return nil
            }
            return CalendarDay(date: date, events: eventsForDate(date))
        }
    }

    // MARK: – Mutation helpers

    func saveEvent(_ event: CalendarEvent) {
        do {
            if event.ekEventIdentifier != nil {
                try eventKitService.updateEvent(event)
            } else {
                try eventKitService.createEvent(event)
            }
            Task { await loadEvents() }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteEvent(_ event: CalendarEvent) {
        do {
            try eventKitService.deleteEvent(event)
            events.removeAll { $0.id == event.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
