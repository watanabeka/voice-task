import SwiftUI

struct CategoryCard: View {
    let category: Category
    let pendingCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category.name)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(hex: category.colorHex))

            Text("\(pendingCount)件")
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: "#95A5A6"))
        }
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: category.colorHex).opacity(0.15))
        )
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}
