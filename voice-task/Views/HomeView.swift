import SwiftUI

struct HomeView: View {
    @Environment(SharedDataStore.self) private var dataStore
    @State private var showAddCategory = false
    @State private var editingCategory: Category?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(dataStore.categories) { category in
                        NavigationLink(value: category) {
                            CategoryCard(
                                category: category,
                                pendingCount: dataStore.pendingTaskCount(for: category.id)
                            )
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button {
                                editingCategory = category
                            } label: {
                                Label("編集", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                dataStore.deleteCategory(category.id)
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(hex: "#F8F9FA"))
            .navigationTitle("ボイスふせん")
            .navigationDestination(for: Category.self) { category in
                TaskListView(category: category)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddCategory = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCategory) {
                CategoryEditSheet(category: nil)
            }
            .sheet(item: $editingCategory) { category in
                CategoryEditSheet(category: category)
            }
        }
    }
}

