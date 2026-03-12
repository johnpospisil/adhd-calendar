import Foundation

struct CalendarEvent: Identifiable, Codable {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var location: String?
    var category: ADHDCategory
    /// Subjective energy cost on a scale of 1 (low) to 5 (high)
    var energyCost: Int
    /// Buffer time in minutes before the next event
    var transitionBuffer: Int
    var notes: String?
    var isAllDay: Bool
    /// Identifier from EventKit when synced with the system calendar
    var ekEventIdentifier: String?

    init(
        id: UUID = UUID(),
        title: String = "",
        startDate: Date = Date(),
        endDate: Date = Date().addingTimeInterval(3600),
        location: String? = nil,
        category: ADHDCategory = .other,
        energyCost: Int = 2,
        transitionBuffer: Int = 10,
        notes: String? = nil,
        isAllDay: Bool = false,
        ekEventIdentifier: String? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.category = category
        self.energyCost = max(1, min(5, energyCost))
        self.transitionBuffer = max(0, transitionBuffer)
        self.notes = notes
        self.isAllDay = isAllDay
        self.ekEventIdentifier = ekEventIdentifier
    }

    static var preview: CalendarEvent {
        CalendarEvent(
            title: "Team Stand-up",
            startDate: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date()) ?? Date(),
            endDate: Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? Date(),
            location: "Conference Room B",
            category: .work,
            energyCost: 3,
            transitionBuffer: 15,
            notes: "Prepare sprint update before the meeting."
        )
    }
}
