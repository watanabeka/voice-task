import SwiftUI

struct PresetColorPicker: View {
    @Binding var selectedHex: String
    let colors: [String]

    private let columns = Array(repeating: GridItem(.flexible()), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignMetrics.Spacing.sm) {
            ForEach(colors, id: \.self) { hex in
                colorCircle(hex: hex)
                    .onTapGesture { selectedHex = hex }
            }
        }
        .padding(.vertical, DesignMetrics.Spacing.xs)
    }

    private func colorCircle(hex: String) -> some View {
        let isSelected = selectedHex == hex
        let color = Color(hex: hex)

        return Circle()
            .fill(color)
            .frame(width: DesignMetrics.Size.colorPickerCircle, height: DesignMetrics.Size.colorPickerCircle)
            .overlay(
                Circle()
                    .strokeBorder(.white, lineWidth: 3)
                    .opacity(isSelected ? 1 : 0)
            )
            .overlay(
                Circle()
                    .strokeBorder(color.opacity(0.5), lineWidth: 2)
                    .opacity(isSelected ? 1 : 0)
                    .scaleEffect(DesignMetrics.Animation.colorPickerOuterScale)
            )
    }
}
