import AppIntents
import WidgetKit

struct StartRecordingIntent: AppIntent {
    static var title: LocalizedStringResource = "録音開始"
    static var description: IntentDescription = "アプリを開いて録音を開始します"
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        let category = WidgetDataStore.selectedCategory()
        let categoryId = category?.id.uuidString ?? ""
        return .result()
    }
}
