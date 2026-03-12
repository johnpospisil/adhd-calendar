import Foundation

enum CalendarDensity {
    case light
    case moderate
    case heavy

    var displayName: String {
        switch self {
        case .light:    return "Light"
        case .moderate: return "Moderate"
        case .heavy:    return "Heavy"
        }
    }
}

struct CalendarDay: Identifiable {
    var id: UUID
    var date: Date
    var events: [CalendarEvent]

    init(id: UUID = UUID(), date: Date, events: [CalendarEvent] = []) {
        self.id = id
        self.date = date
        self.events = events
    }

    /// Sum of energy costs for all events on this day
    var totalEnergyCost: Int {
        events.reduce(0) { $0 + $1.energyCost }
    }

    /// Density based on number of events
    var densityIndicator: CalendarDensity {
        switch events.count {
        case 0...2:  return .light
        case 3...5:  return .moderate
        default:     return .heavy
        }
    }
}
