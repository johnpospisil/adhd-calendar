import SwiftUI

extension Color {
    /// Creates a Color from a hex string, e.g. "#7BA17B" or "7BA17B"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8)  & 0xFF) / 255
            b = Double(int         & 0xFF) / 255
            a = 1
        case 8:
            r = Double((int >> 24) & 0xFF) / 255
            g = Double((int >> 16) & 0xFF) / 255
            b = Double((int >> 8)  & 0xFF) / 255
            a = Double(int         & 0xFF) / 255
        default:
            r = 0; g = 0; b = 0; a = 1
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }

    // MARK: – ADHD-friendly palette

    /// Muted sage green — Self Care
    static let adhdSage        = Color(hex: "7BA17B")
    /// Soft warm blue — Work
    static let adhdWarmBlue    = Color(hex: "6B8CAE")
    /// Muted coral — Social
    static let adhdSoftCoral   = Color(hex: "C4826E")
    /// Warm neutral gray — Errands
    static let adhdWarmGray    = Color(hex: "9E9589")
    /// Soft lavender — Health
    static let adhdLavender    = Color(hex: "9B8DB8")
    /// Muted amber — Creative
    static let adhdAmber       = Color(hex: "C4A55A")
    /// Soft navy — Rest
    static let adhdSoftNavy    = Color(hex: "4A6580")
    /// Soft mint — Routine
    static let adhdMint        = Color(hex: "6BAF9B")
    /// Dusty rose — Appointments
    static let adhdDustyRose   = Color(hex: "B8798A")
    /// Medium gray — Other
    static let adhdMediumGray  = Color(hex: "808080")
}
