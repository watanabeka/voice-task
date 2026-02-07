import Foundation

struct Category: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var name: String
    var colorHex: String
    var order: Int
    var createdAt: Date

    init(id: UUID = UUID(), name: String, colorHex: String, order: Int, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.order = order
        self.createdAt = createdAt
    }

    static let defaults: [Category] = [
        Category(name: "カテゴリ", colorHex: "#4A90D9", order: 0),
    ]
}

struct TaskItem: Identifiable, Codable, Sendable {
    let id: UUID
    var text: String
    var categoryId: UUID
    var isDone: Bool
    var createdAt: Date

    init(id: UUID = UUID(), text: String, categoryId: UUID, isDone: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.text = text
        self.categoryId = categoryId
        self.isDone = isDone
        self.createdAt = createdAt
    }
}
