import Foundation
import EventKit
import Observation

@Observable
class EventKitService {
    private let store = EKEventStore()
    private(set) var authorizationStatus: EKAuthorizationStatus = .notDetermined

    init() {
        refreshAuthorizationStatus()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(storeChanged),
            name: .EKEventStoreChanged,
            object: store
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: – Authorization

    private func refreshAuthorizationStatus() {
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }

    /// Requests full calendar access (iOS 17+).
    func requestAccess() async throws {
        let granted = try await store.requestFullAccessToEvents()
        await MainActor.run {
            authorizationStatus = granted
                ? .fullAccess
                : EKEventStore.authorizationStatus(for: .event)
        }
    }

    // MARK: – CRUD

    func fetchEvents(from start: Date, to end: Date) -> [CalendarEvent] {
        guard authorizationStatus == .fullAccess else { return [] }

        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
        let ekEvents = store.events(matching: predicate)

        return ekEvents.map { CalendarEvent(from: $0) }
    }

    func createEvent(_ event: CalendarEvent) throws {
        guard authorizationStatus == .fullAccess else {
            throw EventKitError.accessDenied
        }

        let ekEvent = EKEvent(eventStore: store)
        ekEvent.apply(from: event, store: store)
        try store.save(ekEvent, span: .thisEvent)
    }

    func updateEvent(_ event: CalendarEvent) throws {
        guard authorizationStatus == .fullAccess else {
            throw EventKitError.accessDenied
        }

        if let identifier = event.ekEventIdentifier,
           let ekEvent = store.event(withIdentifier: identifier) {
            ekEvent.apply(from: event, store: store)
            try store.save(ekEvent, span: .thisEvent)
        } else {
            try createEvent(event)
        }
    }

    func deleteEvent(_ event: CalendarEvent) throws {
        guard authorizationStatus == .fullAccess else {
            throw EventKitError.accessDenied
        }

        guard let identifier = event.ekEventIdentifier,
              let ekEvent = store.event(withIdentifier: identifier) else {
            throw EventKitError.eventNotFound
        }

        try store.remove(ekEvent, span: .thisEvent)
    }

    // MARK: – Observer

    @objc private func storeChanged() {
        refreshAuthorizationStatus()
    }
}

// MARK: – Errors

enum EventKitError: LocalizedError {
    case accessDenied
    case eventNotFound

    var errorDescription: String? {
        switch self {
        case .accessDenied:  return "Calendar access was denied. Please enable it in Settings."
        case .eventNotFound: return "The event could not be found in your calendar."
        }
    }
}

// MARK: – CalendarEvent ↔ EKEvent helpers

private extension CalendarEvent {
    init(from ekEvent: EKEvent) {
        self.init(
            title: ekEvent.title ?? "Untitled",
            startDate: ekEvent.startDate,
            endDate: ekEvent.endDate,
            location: ekEvent.location,
            category: .other,
            energyCost: 2,
            transitionBuffer: 10,
            isAllDay: ekEvent.isAllDay,
            ekEventIdentifier: ekEvent.eventIdentifier
        )
    }
}

private extension EKEvent {
    func apply(from event: CalendarEvent, store: EKEventStore) {
        title = event.title
        startDate = event.startDate
        endDate = event.endDate
        location = event.location
        notes = event.notes
        isAllDay = event.isAllDay
        calendar = store.defaultCalendarForNewEvents
    }
}
