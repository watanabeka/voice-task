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
                    PresetColorPicker(
                        selectedHex: $selectedColorHex,
                        colors: AppConstants.presetColors
                    )
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
