import SwiftUI

/// A colored time block shown in DayView's hourly timeline
struct TimeBlockView: View {
    let event: CalendarEvent
    var onTap: (() -> Void)?

    private var durationMinutes: Double {
        event.endDate.timeIntervalSince(event.startDate) / 60
    }

    /// Height proportional to duration: 1 hour = 60 pt
    private var blockHeight: CGFloat {
        CGFloat(max(durationMinutes, 30)) * 1.0
    }

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(event.category.color)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    if durationMinutes >= 30 {
                        Text("\(event.startDate.displayTime) – \(event.endDate.displayTime)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, minHeight: blockHeight, alignment: .top)
            .background(event.category.color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(event.category.color.opacity(0.3), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 8) {
        TimeBlockView(event: .preview)
        TimeBlockView(event: CalendarEvent(
            title: "Quick Errand",
            startDate: Date(),
            endDate: Date().addingTimeInterval(1800),
            category: .errand,
            energyCost: 1
        ))
    }
    .padding()
}
