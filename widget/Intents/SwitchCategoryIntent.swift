import AppIntents
import WidgetKit

struct SwitchCategoryIntent: AppIntent {
    static var title: LocalizedStringResource = "カテゴリ切替"
    static var description: IntentDescription = "ウィジェットのカテゴリを切り替えます"

    @Parameter(title: "Direction")
    var direction: Int

    init() {
        self.direction = 1
    }

    init(direction: Int) {
        self.direction = direction
    }

    func perform() async throws -> some IntentResult {
        WidgetDataStore.switchCategory(direction: direction)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
