import SwiftUI

enum ADHDCategory: String, CaseIterable, Codable {
    case selfCare = "selfCare"
    case work = "work"
    case social = "social"
    case errand = "errand"
    case health = "health"
    case creative = "creative"
    case rest = "rest"
    case routine = "routine"
    case appointment = "appointment"
    case other = "other"

    var displayName: String {
        switch self {
        case .selfCare:    return "Self Care"
        case .work:        return "Work"
        case .social:      return "Social"
        case .errand:      return "Errand"
        case .health:      return "Health"
        case .creative:    return "Creative"
        case .rest:        return "Rest"
        case .routine:     return "Routine"
        case .appointment: return "Appointment"
        case .other:       return "Other"
        }
    }

    /// Name key used to look up a color in ADHDColorPalette
    var colorName: String {
        switch self {
        case .selfCare:    return "adhd.sage"
        case .work:        return "adhd.warmBlue"
        case .social:      return "adhd.softCoral"
        case .errand:      return "adhd.warmGray"
        case .health:      return "adhd.lavender"
        case .creative:    return "adhd.amber"
        case .rest:        return "adhd.softNavy"
        case .routine:     return "adhd.mint"
        case .appointment: return "adhd.dustyRose"
        case .other:       return "adhd.mediumGray"
        }
    }

    var color: Color {
        switch self {
        case .selfCare:    return .adhdSage
        case .work:        return .adhdWarmBlue
        case .social:      return .adhdSoftCoral
        case .errand:      return .adhdWarmGray
        case .health:      return .adhdLavender
        case .creative:    return .adhdAmber
        case .rest:        return .adhdSoftNavy
        case .routine:     return .adhdMint
        case .appointment: return .adhdDustyRose
        case .other:       return .adhdMediumGray
        }
    }

    var sfSymbol: String {
        switch self {
        case .selfCare:    return "heart.fill"
        case .work:        return "briefcase.fill"
        case .social:      return "person.2.fill"
        case .errand:      return "bag.fill"
        case .health:      return "cross.fill"
        case .creative:    return "paintbrush.fill"
        case .rest:        return "moon.fill"
        case .routine:     return "repeat"
        case .appointment: return "calendar.badge.clock"
        case .other:       return "circle.fill"
        }
    }
}
