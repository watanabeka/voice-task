import Foundation

struct WidgetDataStore: Sendable {
    private static var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID)
    }

    private static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: AppConstants.appGroupID)
    }

    // MARK: - Load

    static func loadCategories() -> [Category] {
        guard let url = containerURL?.appendingPathComponent(AppConstants.categoriesFileName),
              FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let categories = try? JSONDecoder().decode([Category].self, from: data),
              !categories.isEmpty else {
            return []
        }
        return categories.sorted { $0.order < $1.order }
    }

    static func loadTasks() -> [TaskItem] {
        guard let url = containerURL?.appendingPathComponent(AppConstants.tasksFileName),
              FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let tasks = try? JSONDecoder().decode([TaskItem].self, from: data) else {
            return []
        }
        return tasks
    }

    // MARK: - Category Selection

    static var selectedCategoryIndex: Int {
        get { sharedDefaults?.integer(forKey: AppConstants.selectedCategoryIndexKey) ?? 0 }
        set { sharedDefaults?.set(newValue, forKey: AppConstants.selectedCategoryIndexKey) }
    }

    static func selectedCategory() -> Category? {
        let categories = loadCategories()
        guard !categories.isEmpty else { return nil }
        let index = max(0, min(selectedCategoryIndex, categories.count - 1))
        return categories[index]
    }

    static func pendingTaskCount(for categoryId: UUID) -> Int {
        loadTasks().filter { $0.categoryId == categoryId && !$0.isDone }.count
    }

    static func switchCategory(direction: Int) {
        let categories = loadCategories()
        guard !categories.isEmpty else { return }
        var newIndex = selectedCategoryIndex + direction
        if newIndex < 0 { newIndex = categories.count - 1 }
        if newIndex >= categories.count { newIndex = 0 }
        selectedCategoryIndex = newIndex
    }
}
