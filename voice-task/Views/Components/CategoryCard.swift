import SwiftUI

struct CategoryCard: View {
    let category: Category
    let pendingCount: Int

    private var categoryColor: Color { Color(hex: category.colorHex) }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignMetrics.Spacing.xs) {
            Text(category.name)
                .font(.system(size: DesignMetrics.FontSize.headline, weight: .semibold))
                .foregroundStyle(categoryColor)

            Text("\(pendingCount)件")
                .font(.system(size: DesignMetrics.FontSize.caption))
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: DesignMetrics.Size.categoryCardMinHeight, alignment: .leading)
        .padding(DesignMetrics.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignMetrics.CornerRadius.card)
                .fill(categoryColor.opacity(DesignMetrics.Opacity.categoryBackground))
        )
        .appShadow(DesignMetrics.cardShadow)
    }
}
