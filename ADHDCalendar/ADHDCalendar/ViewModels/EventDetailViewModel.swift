import Foundation
import Observation

@Observable
class EventDetailViewModel {
    var event: CalendarEvent
    var isEditing: Bool = false

    let calendarViewModel: CalendarViewModel

    init(event: CalendarEvent, calendarViewModel: CalendarViewModel) {
        self.event = event
        self.calendarViewModel = calendarViewModel
    }

    func save() {
        calendarViewModel.saveEvent(event)
        isEditing = false
    }

    func delete() {
        calendarViewModel.deleteEvent(event)
    }
}
