import SwiftUI

struct CategoryEditSheet: View {
    @Environment(SharedDataStore.self) private var dataStore
    @Environment(\.dismiss) private var dismiss

    let category: Category?

    @State private var name: String = ""
    @State private var selectedColorHex: String = AppConstants.presetColors[0]

    private var isEditing: Bool { category != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("カテゴリ名") {
                    TextField("カテゴリ名を入力", text: $name)
                }

                Section("カラー") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(AppConstants.presetColors, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 3)
                                        .opacity(selectedColorHex == hex ? 1 : 0)
                                )
                                .overlay(
                                    Circle()
                                        .strokeBorder(Color(hex: hex).opacity(0.5), lineWidth: 2)
                                        .opacity(selectedColorHex == hex ? 1 : 0)
                                        .scaleEffect(1.15)
                                )
                                .onTapGesture {
                                    selectedColorHex = hex
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle(isEditing ? "カテゴリを編集" : "カテゴリを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        save()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let category {
                    name = category.name
                    selectedColorHex = category.colorHex
                }
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        if var existing = category {
            existing.name = trimmedName
            existing.colorHex = selectedColorHex
            dataStore.updateCategory(existing)
        } else {
            let newCategory = Category(
                name: trimmedName,
                colorHex: selectedColorHex,
                order: dataStore.categories.count
            )
            dataStore.addCategory(newCategory)
        }
        dataStore.reloadWidgetTimelines()
    }
}
