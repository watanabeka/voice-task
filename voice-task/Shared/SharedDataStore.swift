import Foundation
import SwiftUI
import WidgetKit

@Observable
final class SharedDataStore: @unchecked Sendable {
    var categories: [Category] = []
    var tasks: [TaskItem] = []

    private let defaults: UserDefaults

    init() {
        self.defaults = UserDefaults(suiteName: AppConstants.appGroupID) ?? .standard
        loadAll()
    }

    // MARK: - Load

    func loadAll() {
        loadCategories()
        loadTasks()
    }

    func loadCategories() {
        guard let data = defaults.data(forKey: AppConstants.categoriesKey) else { return }
        do {
            categories = try JSONDecoder().decode([Category].self, from: data)
            categories.sort { $0.order < $1.order }
        } catch {
            print("Failed to load categories: \(error)")
        }
    }

    func loadTasks() {
        guard let data = defaults.data(forKey: AppConstants.tasksKey) else { return }
        do {
            tasks = try JSONDecoder().decode([TaskItem].self, from: data)
        } catch {
            print("Failed to load tasks: \(error)")
        }
    }

    // MARK: - Save

    func saveCategories() {
        guard let data = try? JSONEncoder().encode(categories) else { return }
        defaults.set(data, forKey: AppConstants.categoriesKey)
    }

    func saveTasks() {
        guard let data = try? JSONEncoder().encode(tasks) else { return }
        defaults.set(data, forKey: AppConstants.tasksKey)
    }

    // MARK: - Category Operations

    func initializeDefaultsIfNeeded() {
        guard categories.isEmpty else {
            reloadWidgetTimelines()
            return
        }
        categories = Category.defaults
        saveCategories()

        let sampleTask = TaskItem(text: "ここにタスクが追加されます", categoryId: categories[0].id)
        tasks.append(sampleTask)
        saveTasks()

        reloadWidgetTimelines()
    }

    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
        reloadWidgetTimelines()
    }

    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
            reloadWidgetTimelines()
        }
    }

    func deleteCategory(_ categoryId: UUID) {
        categories.removeAll { $0.id == categoryId }
        tasks.removeAll { $0.categoryId == categoryId }
        saveCategories()
        saveTasks()
        reloadWidgetTimelines()
    }

    func moveCategory(from source: IndexSet, to destination: Int) {
        categories.move(fromOffsets: source, toOffset: destination)
        for (index, _) in categories.enumerated() {
            categories[index].order = index
        }
        saveCategories()
    }

    // MARK: - Task Operations

    func addTask(_ task: TaskItem) {
        tasks.append(task)
        saveTasks()
        reloadWidgetTimelines()
    }

    func addTaskFromSpeech(_ text: String, categoryId: UUID) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        addTask(TaskItem(text: trimmed, categoryId: categoryId))
    }

    func toggleTask(_ taskId: UUID) {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].isDone.toggle()
            saveTasks()
        }
    }

    func deleteTask(_ taskId: UUID) {
        tasks.removeAll { $0.id == taskId }
        saveTasks()
    }

    func tasksForCategory(_ categoryId: UUID) -> [TaskItem] {
        tasks.filter { $0.categoryId == categoryId }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func pendingTaskCount(for categoryId: UUID) -> Int {
        tasks.filter { $0.categoryId == categoryId && !$0.isDone }.count
    }

    // MARK: - Widget Category Selection

    var selectedCategoryIndex: Int {
        get { defaults.integer(forKey: AppConstants.selectedCategoryIndexKey) }
        set { defaults.set(newValue, forKey: AppConstants.selectedCategoryIndexKey) }
    }

    var selectedCategory: Category? {
        guard !categories.isEmpty else { return nil }
        let clamped = max(0, min(selectedCategoryIndex, categories.count - 1))
        return categories[clamped]
    }

    func categoryColor(for categoryId: UUID) -> Color {
        let hex = categories.first { $0.id == categoryId }?.colorHex
        return Color(hex: hex ?? AppConstants.presetColors[0])
    }

    func switchCategory(direction: Int) {
        guard !categories.isEmpty else { return }
        var newIndex = selectedCategoryIndex + direction
        if newIndex < 0 { newIndex = categories.count - 1 }
        if newIndex >= categories.count { newIndex = 0 }
        selectedCategoryIndex = newIndex
    }

    // MARK: - Widget

    func reloadWidgetTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
