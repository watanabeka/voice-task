import SwiftUI

enum DesignMetrics {
    enum FontSize {
        static let title: CGFloat = 28
        static let headline: CGFloat = 17
        static let body: CGFloat = 15
        static let caption: CGFloat = 12
        static let widgetLabel: CGFloat = 10
        static let icon: CGFloat = 22
        static let widgetIcon: CGFloat = 18
        static let widgetChevron: CGFloat = 12
    }

    enum Spacing {
        static let xl: CGFloat = 32
        static let lg: CGFloat = 24
        static let md: CGFloat = 16
        static let sm: CGFloat = 12
        static let xs: CGFloat = 8
        static let xxs: CGFloat = 4
        static let widget: CGFloat = 12
        static let widgetSpacing: CGFloat = 6
    }

    enum CornerRadius {
        static let card: CGFloat = 16
        static let overlay: CGFloat = 24
    }

    enum Size {
        static let recordButton: CGFloat = 56
        static let recordPulse: CGFloat = 70
        static let colorPickerCircle: CGFloat = 44
        static let widgetRecordButton: CGFloat = 44
        static let categoryCardMinHeight: CGFloat = 90
    }

    enum Opacity {
        static let categoryBackground: Double = 0.15
        static let widgetBackground: Double = 0.12
        static let pulseFill: Double = 0.2
        static let dimmedOverlay: Double = 0.4
        static let doneTask: Double = 0.6
        static let cardShadow: Double = 0.06
        static let buttonShadow: Double = 0.15
        static let overlayShadow: Double = 0.15
        static let widgetButtonShadow: Double = 0.3
    }

    enum Animation {
        static let pulseScale: CGFloat = 1.3
        static let pulseDuration: Double = 1.0
        static let toggleDuration: Double = 0.25
        static let colorPickerOuterScale: CGFloat = 1.15
    }

    static let cardShadow = ShadowStyle(
        color: .black.opacity(Opacity.cardShadow),
        radius: 8,
        y: 2
    )

    static let buttonShadow = ShadowStyle(
        color: .black.opacity(Opacity.buttonShadow),
        radius: 8,
        y: 4
    )
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let y: CGFloat
}

extension View {
    func appShadow(_ style: ShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, y: style.y)
    }
}
