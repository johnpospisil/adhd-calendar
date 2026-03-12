import Foundation
import Observation

@Observable
class CategoryService {
    /// User-overridden energy defaults; falls back to category defaults if nil
    private var energyOverrides: [ADHDCategory: Int] = [:]
    /// User-overridden transition buffers; falls back to category defaults if nil
    private var bufferOverrides: [ADHDCategory: Int] = [:]

    // MARK: – Energy defaults

    func defaultEnergyForCategory(_ category: ADHDCategory) -> Int {
        if let override = energyOverrides[category] { return override }
        switch category {
        case .selfCare:    return 1
        case .work:        return 3
        case .social:      return 4
        case .errand:      return 2
        case .health:      return 3
        case .creative:    return 2
        case .rest:        return 1
        case .routine:     return 1
        case .appointment: return 4
        case .other:       return 2
        }
    }

    func setEnergyOverride(_ energy: Int, for category: ADHDCategory) {
        energyOverrides[category] = max(1, min(5, energy))
    }

    // MARK: – Transition buffer defaults

    func suggestedTransitionBuffer(_ category: ADHDCategory) -> Int {
        if let override = bufferOverrides[category] { return override }
        switch category {
        case .selfCare:    return 5
        case .work:        return 10
        case .social:      return 20
        case .errand:      return 10
        case .health:      return 15
        case .creative:    return 10
        case .rest:        return 5
        case .routine:     return 5
        case .appointment: return 20
        case .other:       return 10
        }
    }

    func setBufferOverride(_ minutes: Int, for category: ADHDCategory) {
        bufferOverrides[category] = max(0, minutes)
    }
}
