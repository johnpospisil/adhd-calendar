import SwiftUI

struct EventEditView: View {
    @State private var title: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var isAllDay: Bool
    @State private var category: ADHDCategory
    @State private var energyCost: Int
    @State private var transitionBuffer: Int
    @State private var location: String
    @State private var notes: String

    private let existingEvent: CalendarEvent?
    private let calendarViewModel: CalendarViewModel

    @Environment(\.dismiss) private var dismiss

    init(event: CalendarEvent? = nil, calendarViewModel: CalendarViewModel) {
        self.existingEvent = event
        self.calendarViewModel = calendarViewModel

        let ev = event ?? CalendarEvent()
        _title             = State(initialValue: ev.title)
        _startDate         = State(initialValue: ev.startDate)
        _endDate           = State(initialValue: ev.endDate)
        _isAllDay          = State(initialValue: ev.isAllDay)
        _category          = State(initialValue: ev.category)
        _energyCost        = State(initialValue: ev.energyCost)
        _transitionBuffer  = State(initialValue: ev.transitionBuffer)
        _location          = State(initialValue: ev.location ?? "")
        _notes             = State(initialValue: ev.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Event") {
                    TextField("Title", text: $title)
                    Toggle("All Day", isOn: $isAllDay)
                    if isAllDay {
                        DatePicker("Date", selection: $startDate, displayedComponents: .date)
                    } else {
                        DatePicker("Starts", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                        DatePicker("Ends",   selection: $endDate,   displayedComponents: [.date, .hourAndMinute])
                    }
                }

                Section("Location") {
                    TextField("Add location", text: $location)
                }

                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(ADHDCategory.allCases, id: \.self) { cat in
                            Label(cat.displayName, systemImage: cat.sfSymbol)
                                .tag(cat)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }

                Section("ADHD Settings") {
                    Stepper(
                        "Energy Cost: \(energyCost)/5",
                        value: $energyCost,
                        in: 1...5
                    )

                    HStack {
                        Text("Energy")
                        Spacer()
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { dot in
                                Circle()
                                    .fill(dot <= energyCost ? category.color : Color.secondary.opacity(0.3))
                                    .frame(width: 10, height: 10)
                                    .onTapGesture { energyCost = dot }
                            }
                        }
                    }

                    Stepper(
                        "Transition Buffer: \(transitionBuffer) min",
                        value: $transitionBuffer,
                        in: 0...60,
                        step: 5
                    )
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle(existingEvent == nil ? "New Event" : "Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveEvent()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveEvent() {
        var event = existingEvent ?? CalendarEvent()
        event.title            = title.trimmingCharacters(in: .whitespaces)
        event.startDate        = startDate
        event.endDate          = isAllDay ? startDate : endDate
        event.isAllDay         = isAllDay
        event.category         = category
        event.energyCost       = energyCost
        event.transitionBuffer = transitionBuffer
        event.location         = location.isEmpty ? nil : location
        event.notes            = notes.isEmpty ? nil : notes
        calendarViewModel.saveEvent(event)
    }
}

#Preview {
    EventEditView(calendarViewModel: CalendarViewModel())
}
