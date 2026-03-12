import SwiftUI

struct WeekStripView: View {
    @Binding var selectedDate: Date
    let weekDates: [Date]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekDates, id: \.self) { date in
                Button {
                    selectedDate = date
                } label: {
                    VStack(spacing: 4) {
                        Text(date.shortDayName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Text(date.dayNumber)
                            .font(.callout)
                            .fontWeight(date.isToday ? .bold : .regular)
                            .foregroundStyle(isSelected(date) ? .white : (date.isToday ? .accent : .primary))
                            .frame(width: 32, height: 32)
                            .background {
                                if isSelected(date) {
                                    Circle().fill(Color.accentColor)
                                } else if date.isToday {
                                    Circle().fill(Color.accentColor.opacity(0.15))
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color(.secondarySystemBackground))
    }

    private func isSelected(_ date: Date) -> Bool {
        date.isSameDay(as: selectedDate)
    }
}

#Preview {
    @Previewable @State var selected = Date()
    let cal = Calendar.current
    let week = (0..<7).compactMap { cal.date(byAdding: .day, value: $0 - 3, to: Date()) }

    WeekStripView(selectedDate: $selected, weekDates: week)
        .padding()
}
