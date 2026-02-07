import AppIntents
import SwiftUI
import WidgetKit

struct VoiceFusenWidgetEntryView: View {
    var entry: VoiceFusenProvider.Entry

    var body: some View {
        if let category = entry.category {
            activeView(category: category)
        } else {
            emptyView
        }
    }

    // MARK: - データあり

    private func activeView(category: Category) -> some View {
        let color = Color(hex: category.colorHex)

        return VStack(spacing: 6) {
            categoryNavigationRow(category: category, color: color)
            Spacer()
            recordButton(category: category, color: color)
            Spacer()
        }
        .padding(12)
        .containerBackground(for: .widget) {
            ZStack {
                Color.white
                color.opacity(0.12)
            }
        }
    }

    private func categoryNavigationRow(category: Category, color: Color) -> some View {
        HStack {
            Button(intent: SwitchCategoryIntent(direction: -1)) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(color)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(category.name)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(color)
                .lineLimit(1)

            Spacer()

            Button(intent: SwitchCategoryIntent(direction: 1)) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(color)
            }
            .buttonStyle(.plain)
        }
    }

    private func recordButton(category: Category, color: Color) -> some View {
        Link(destination: URL(string: "\(AppConstants.urlScheme)://record?categoryId=\(category.id.uuidString)")!) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "mic.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                )
                .shadow(color: color.opacity(0.3), radius: 4, y: 2)
        }
    }

    // MARK: - データなし（アプリ未起動）

    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "mic.fill")
                .font(.system(size: 24))
                .foregroundStyle(.gray.opacity(0.4))
            Text("アプリを開いて\nセットアップ")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .containerBackground(for: .widget) {
            Color.white
        }
    }
}
