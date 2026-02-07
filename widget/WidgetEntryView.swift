import AppIntents
import SwiftUI
import WidgetKit

struct VoiceFusenWidgetEntryView: View {
    var entry: VoiceFusenProvider.Entry

    private var categoryColor: Color {
        Color(hex: entry.category?.colorHex ?? AppConstants.presetColors[0])
    }

    private var categoryName: String {
        entry.category?.name ?? "カテゴリなし"
    }

    var body: some View {
        VStack(spacing: 6) {
            categoryNavigationRow
            Spacer()
            recordButton
            Spacer()
        }
        .padding(12)
        .containerBackground(for: .widget) {
            ZStack {
                Color.white
                categoryColor.opacity(0.12)
            }
        }
    }

    // MARK: - Subviews

    private var categoryNavigationRow: some View {
        HStack {
            Button(intent: SwitchCategoryIntent(direction: -1)) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(categoryColor)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(categoryName)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(categoryColor)
                .lineLimit(1)

            Spacer()

            Button(intent: SwitchCategoryIntent(direction: 1)) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(categoryColor)
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var recordButton: some View {
        if let category = entry.category,
           let url = URL(string: "\(AppConstants.urlScheme)://record?categoryId=\(category.id.uuidString)") {
            Link(destination: url) {
                Circle()
                    .fill(categoryColor)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "mic.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                    )
                    .shadow(color: categoryColor.opacity(0.3), radius: 4, y: 2)
            }
        }
    }
}
