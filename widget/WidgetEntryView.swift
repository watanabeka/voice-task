import SwiftUI
import WidgetKit

struct VoiceFusenWidgetEntryView: View {
    var entry: VoiceFusenProvider.Entry

    private var categoryColor: Color {
        Color(hex: entry.category?.colorHex ?? "#4A90D9")
    }

    private var categoryName: String {
        entry.category?.name ?? "カテゴリなし"
    }

    var body: some View {
        VStack(spacing: 6) {
            // Category navigation row
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

            Spacer()

            // Record button - opens main app via URL scheme
            if let category = entry.category {
                Link(destination: URL(string: "voicefusen://record?categoryId=\(category.id.uuidString)")!) {
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
}
