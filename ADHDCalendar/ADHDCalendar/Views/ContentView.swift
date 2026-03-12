import SwiftUI

struct ContentView: View {
    @State private var viewModel = CalendarViewModel()
    @State private var showingNewEvent = false

    var body: some View {
        TabView {
            DayView(viewModel: viewModel)
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }

            MonthView(viewModel: viewModel)
                .tabItem {
                    Label("Month", systemImage: "calendar")
                }

            Button {
                showingNewEvent = true
            } label: {
                Label("Add Event", systemImage: "plus.circle.fill")
            }
            .tabItem {
                Label("Add", systemImage: "plus.circle.fill")
            }
        }
        .sheet(isPresented: $showingNewEvent) {
            EventEditView(calendarViewModel: viewModel)
        }
        .task {
            await viewModel.loadEvents()
        }
    }
}

#Preview {
    ContentView()
}
