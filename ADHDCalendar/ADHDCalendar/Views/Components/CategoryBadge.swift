import SwiftUI

struct CategoryBadge: View {
    let category: ADHDCategory

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: category.sfSymbol)
                .font(.caption2)
            Text(category.displayName)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(category.color.opacity(0.2))
        .foregroundStyle(category.color)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(category.color.opacity(0.4), lineWidth: 0.5)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        ForEach(ADHDCategory.allCases, id: \.self) { category in
            CategoryBadge(category: category)
        }
    }
    .padding()
}
