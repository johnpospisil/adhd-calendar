import SwiftUI

/// Central palette of sensory-friendly, muted colors for ADHD/AuDHD users.
/// Colors are defined here and referenced by ADHDCategory for consistency.
struct ADHDColorPalette {
    /// Muted sage green — calm, nurturing
    static let sage       = Color.adhdSage
    /// Soft warm blue — focused, professional
    static let warmBlue   = Color.adhdWarmBlue
    /// Muted coral — social warmth without harshness
    static let softCoral  = Color.adhdSoftCoral
    /// Warm neutral gray — neutral, grounding
    static let warmGray   = Color.adhdWarmGray
    /// Soft lavender — gentle, healing
    static let lavender   = Color.adhdLavender
    /// Muted amber — creative energy
    static let amber      = Color.adhdAmber
    /// Soft navy — restful, deep
    static let softNavy   = Color.adhdSoftNavy
    /// Soft mint — fresh, habitual
    static let mint       = Color.adhdMint
    /// Dusty rose — gentle importance
    static let dustyRose  = Color.adhdDustyRose
    /// Medium gray — neutral default
    static let mediumGray = Color.adhdMediumGray

    /// Returns the palette color for a given category
    static func color(for category: ADHDCategory) -> Color {
        category.color
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 12) {
            ForEach(ADHDCategory.allCases, id: \.self) { category in
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ADHDColorPalette.color(for: category))
                        .frame(width: 40, height: 40)
                    Text(category.displayName)
                        .font(.body)
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}
