import SwiftUI

struct EventDetailView: View {
    @State private var viewModel: EventDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(event: CalendarEvent, calendarViewModel: CalendarViewModel) {
        _viewModel = State(initialValue: EventDetailViewModel(
            event: event,
            calendarViewModel: calendarViewModel
        ))
    }

    var body: some View {
        NavigationStack {
            List {
                // Title & Category
                Section {
                    HStack {
                        Image(systemName: viewModel.event.category.sfSymbol)
                            .foregroundStyle(viewModel.event.category.color)
                            .font(.title2)
                        Text(viewModel.event.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    CategoryBadge(category: viewModel.event.category)
                }

                // Date & Time
                Section("Date & Time") {
                    if viewModel.event.isAllDay {
                        Label("All Day", systemImage: "sun.max")
                        Label(viewModel.event.startDate.dayString, systemImage: "calendar")
                    } else {
                        Label(viewModel.event.startDate.dayString, systemImage: "calendar")
                        Label(
                            "\(viewModel.event.startDate.displayTime) – \(viewModel.event.endDate.displayTime)",
                            systemImage: "clock"
                        )
                    }
                }

                // Location
                if let location = viewModel.event.location, !location.isEmpty {
                    Section("Location") {
                        Label(location, systemImage: "mappin.and.ellipse")
                    }
                }

                // ADHD Properties
                Section("ADHD Details") {
                    HStack {
                        Label("Energy Cost", systemImage: "bolt.fill")
                        Spacer()
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { dot in
                                Circle()
                                    .fill(dot <= viewModel.event.energyCost
                                          ? viewModel.event.category.color
                                          : Color.secondary.opacity(0.3))
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }

                    Label(
                        "\(viewModel.event.transitionBuffer) min transition buffer",
                        systemImage: "timer"
                    )
                }

                // Notes
                if let notes = viewModel.event.notes, !notes.isEmpty {
                    Section("Notes") {
                        Text(notes)
                            .font(.body)
                    }
                }

                // Delete
                Section {
                    Button(role: .destructive) {
                        viewModel.delete()
                        dismiss()
                    } label: {
                        Label("Delete Event", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        viewModel.isEditing = true
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(isPresented: $viewModel.isEditing) {
                EventEditView(
                    event: viewModel.event,
                    calendarViewModel: viewModel.calendarViewModel
                )
            }
        }
    }
}

#Preview {
    EventDetailView(event: .preview, calendarViewModel: CalendarViewModel())
}
