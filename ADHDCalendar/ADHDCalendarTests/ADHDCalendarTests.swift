import XCTest
@testable import ADHDCalendar

final class ADHDCalendarTests: XCTestCase {

    // MARK: – ADHDCategory

    func testCategoryDisplayNames() {
        XCTAssertEqual(ADHDCategory.selfCare.displayName, "Self Care")
        XCTAssertEqual(ADHDCategory.work.displayName, "Work")
        XCTAssertEqual(ADHDCategory.social.displayName, "Social")
        XCTAssertEqual(ADHDCategory.errand.displayName, "Errand")
        XCTAssertEqual(ADHDCategory.health.displayName, "Health")
        XCTAssertEqual(ADHDCategory.creative.displayName, "Creative")
        XCTAssertEqual(ADHDCategory.rest.displayName, "Rest")
        XCTAssertEqual(ADHDCategory.routine.displayName, "Routine")
        XCTAssertEqual(ADHDCategory.appointment.displayName, "Appointment")
        XCTAssertEqual(ADHDCategory.other.displayName, "Other")
    }

    func testCategoryColorNames() {
        XCTAssertEqual(ADHDCategory.selfCare.colorName, "adhd.sage")
        XCTAssertEqual(ADHDCategory.work.colorName, "adhd.warmBlue")
        XCTAssertFalse(ADHDCategory.health.colorName.isEmpty)
    }

    func testCategorySFSymbols() {
        for category in ADHDCategory.allCases {
            XCTAssertFalse(category.sfSymbol.isEmpty, "\(category) has no SF symbol")
        }
    }

    func testAllCategoriesPresent() {
        XCTAssertEqual(ADHDCategory.allCases.count, 10)
    }

    // MARK: – CalendarEvent

    func testEventDefaultValues() {
        let event = CalendarEvent()
        XCTAssertFalse(event.id.uuidString.isEmpty)
        XCTAssertEqual(event.category, .other)
        XCTAssertEqual(event.energyCost, 2)
        XCTAssertEqual(event.transitionBuffer, 10)
        XCTAssertFalse(event.isAllDay)
        XCTAssertNil(event.location)
        XCTAssertNil(event.notes)
        XCTAssertNil(event.ekEventIdentifier)
    }

    func testEventEnergyCostClamped() {
        let low = CalendarEvent(energyCost: 0)
        XCTAssertEqual(low.energyCost, 1)

        let high = CalendarEvent(energyCost: 10)
        XCTAssertEqual(high.energyCost, 5)
    }

    func testEventTransitionBufferNonNegative() {
        let event = CalendarEvent(transitionBuffer: -5)
        XCTAssertEqual(event.transitionBuffer, 0)
    }

    func testEventPreviewIsValid() {
        let preview = CalendarEvent.preview
        XCTAssertFalse(preview.title.isEmpty)
        XCTAssertEqual(preview.category, .work)
        XCTAssertGreaterThan(preview.endDate, preview.startDate)
    }

    // MARK: – CalendarDay

    func testCalendarDayTotalEnergyCost() {
        let events = [
            CalendarEvent(energyCost: 3),
            CalendarEvent(energyCost: 2),
            CalendarEvent(energyCost: 4)
        ]
        let day = CalendarDay(date: Date(), events: events)
        XCTAssertEqual(day.totalEnergyCost, 9)
    }

    func testCalendarDayEmptyEnergyCost() {
        let day = CalendarDay(date: Date(), events: [])
        XCTAssertEqual(day.totalEnergyCost, 0)
    }

    func testCalendarDayDensityLight() {
        let day = CalendarDay(date: Date(), events: [CalendarEvent(), CalendarEvent()])
        XCTAssertEqual(day.densityIndicator, .light)
    }

    func testCalendarDayDensityModerate() {
        let events = Array(repeating: CalendarEvent(), count: 4)
        let day = CalendarDay(date: Date(), events: events)
        XCTAssertEqual(day.densityIndicator, .moderate)
    }

    func testCalendarDayDensityHeavy() {
        let events = Array(repeating: CalendarEvent(), count: 7)
        let day = CalendarDay(date: Date(), events: events)
        XCTAssertEqual(day.densityIndicator, .heavy)
    }

    // MARK: – Date Extensions

    func testStartOfDay() {
        let now = Date()
        let start = now.startOfDay
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: start)
        XCTAssertEqual(components.hour, 0)
        XCTAssertEqual(components.minute, 0)
        XCTAssertEqual(components.second, 0)
    }

    func testEndOfDay() {
        let now = Date()
        let end = now.endOfDay
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: end)
        XCTAssertEqual(components.hour, 23)
        XCTAssertEqual(components.minute, 59)
        XCTAssertEqual(components.second, 59)
    }

    func testStartOfMonth() {
        let now = Date()
        let start = now.startOfMonth
        let components = Calendar.current.dateComponents([.day, .hour], from: start)
        XCTAssertEqual(components.day, 1)
        XCTAssertEqual(components.hour, 0)
    }

    func testEndOfMonth() {
        let now = Date()
        let end = now.endOfMonth
        XCTAssertGreaterThan(end, now.startOfMonth)
    }

    func testIsToday() {
        XCTAssertTrue(Date().isToday)
    }

    func testIsSameDay() {
        let today = Date()
        let alsoToday = today.addingTimeInterval(3600)
        XCTAssertTrue(today.isSameDay(as: alsoToday))
    }

    func testIsSameDayDifferentDays() {
        let today = Date()
        let tomorrow = today.addingTimeInterval(86400)
        XCTAssertFalse(today.isSameDay(as: tomorrow))
    }

    func testDisplayTimeNotEmpty() {
        XCTAssertFalse(Date().displayTime.isEmpty)
    }

    func testMonthYearStringNotEmpty() {
        XCTAssertFalse(Date().monthYearString.isEmpty)
    }

    func testDayNumberNotEmpty() {
        XCTAssertFalse(Date().dayNumber.isEmpty)
    }

    func testShortDayNameNotEmpty() {
        XCTAssertFalse(Date().shortDayName.isEmpty)
    }
}
