import WidgetKit
import SwiftUI

struct VoiceFusenWidget: Widget {
    let kind: String = "VoiceFusenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VoiceFusenProvider()) { entry in
            VoiceFusenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ボイスふせん")
        .description("音声でタスクを素早く追加")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    VoiceFusenWidget()
} timeline: {
    VoiceFusenEntry(
        date: .now,
        category: Category(name: "仕事", colorHex: "#4A90D9", order: 0),
        pendingCount: 3
    )
}
