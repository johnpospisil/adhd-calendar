import SwiftUI

struct EventCard: View {
    let event: CalendarEvent

    var body: some View {
        HStack(spacing: 12) {
            // Left color stripe
            RoundedRectangle(cornerRadius: 2)
                .fill(event.category.color)
                .frame(width: 4)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    if event.isAllDay {
                        Text("All Day")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("\(event.startDate.displayTime) – \(event.endDate.displayTime)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    CategoryBadge(category: event.category)
                }

                // Energy cost dots
                HStack(spacing: 3) {
                    ForEach(1...5, id: \.self) { dot in
                        Circle()
                            .fill(dot <= event.energyCost
                                  ? event.category.color
                                  : event.category.color.opacity(0.2))
                            .frame(width: 7, height: 7)
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 12) {
        EventCard(event: .preview)
        EventCard(event: CalendarEvent(
            title: "Morning Walk",
            startDate: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date(),
            endDate:   Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date()) ?? Date(),
            category: .selfCare,
            energyCost: 1
        ))
    }
    .padding()
}
