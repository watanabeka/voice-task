import Foundation
import SwiftUI
import WidgetKit

@Observable
final class SharedDataStore: @unchecked Sendable {
    var categories: [Category] = []
    var tasks: [TaskItem] = []

    private let fileManager = FileManager.default

    private var containerURL: URL? {
        fileManager.containerURL(forSecurityApplicationGroupIdentifier: AppConstants.appGroupID)
    }

    private var categoriesFileURL: URL? {
        containerURL?.appendingPathComponent(AppConstants.categoriesFileName)
    }

    private var tasksFileURL: URL? {
        containerURL?.appendingPathComponent(AppConstants.tasksFileName)
    }

    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: AppConstants.appGroupID)
    }

    init() {
        loadAll()
    }

    // MARK: - Load

    func loadAll() {
        loadCategories()
        loadTasks()
    }

    func loadCategories() {
        guard let url = categoriesFileURL,
              fileManager.fileExists(atPath: url.path) else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            categories = try JSONDecoder().decode([Category].self, from: data)
            categories.sort { $0.order < $1.order }
        } catch {
            print("Failed to load categories: \(error)")
        }
    }

    func loadTasks() {
        guard let url = tasksFileURL,
              fileManager.fileExists(atPath: url.path) else {
            return
        }
        do {
            let data = try Data(contentsOf: url)
            tasks = try JSONDecoder().decode([TaskItem].self, from: data)
        } catch {
            print("Failed to load tasks: \(error)")
        }
    }

    // MARK: - Save

    func saveCategories() {
        guard let url = categoriesFileURL else { return }
        do {
            let data = try JSONEncoder().encode(categories)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save categories: \(error)")
        }
    }

    func saveTasks() {
        guard let url = tasksFileURL else { return }
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save tasks: \(error)")
        }
    }

    // MARK: - Category Operations

    func initializeDefaultsIfNeeded() {
        let defaults = sharedDefaults
        if defaults?.bool(forKey: AppConstants.hasLaunchedBeforeKey) != true {
            categories = Category.defaults
            saveCategories()
            defaults?.set(true, forKey: AppConstants.hasLaunchedBeforeKey)
        }
    }

    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }

    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
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
        get { sharedDefaults?.integer(forKey: AppConstants.selectedCategoryIndexKey) ?? 0 }
        set {
            sharedDefaults?.set(newValue, forKey: AppConstants.selectedCategoryIndexKey)
        }
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
