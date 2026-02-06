import WidgetKit

struct VoiceFusenEntry: TimelineEntry {
    let date: Date
    let category: Category?
    let pendingCount: Int
}

struct VoiceFusenProvider: TimelineProvider {
    func placeholder(in context: Context) -> VoiceFusenEntry {
        VoiceFusenEntry(
            date: Date(),
            category: Category(name: "仕事", colorHex: "#4A90D9", order: 0),
            pendingCount: 0
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (VoiceFusenEntry) -> Void) {
        let category = WidgetDataStore.selectedCategory()
        let count = category.map { WidgetDataStore.pendingTaskCount(for: $0.id) } ?? 0
        let entry = VoiceFusenEntry(date: Date(), category: category, pendingCount: count)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<VoiceFusenEntry>) -> Void) {
        let category = WidgetDataStore.selectedCategory()
        let count = category.map { WidgetDataStore.pendingTaskCount(for: $0.id) } ?? 0
        let entry = VoiceFusenEntry(date: Date(), category: category, pendingCount: count)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}
