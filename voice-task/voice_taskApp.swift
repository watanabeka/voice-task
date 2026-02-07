import SwiftUI

@main
struct VoiceFusenApp: App {
    @State private var dataStore = SharedDataStore()
    @State private var showRecordingOverlay = false
    @State private var recordingCategoryId: UUID?

    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView()
                    .environment(dataStore)

                if showRecordingOverlay, let categoryId = recordingCategoryId {
                    RecordingOverlayView(categoryId: categoryId) {
                        showRecordingOverlay = false
                        recordingCategoryId = nil
                    }
                    .environment(dataStore)
                }
            }
            .onOpenURL { url in
                guard url.scheme == AppConstants.urlScheme,
                      url.host == "record",
                      let categoryId = extractCategoryId(from: url) else { return }
                recordingCategoryId = categoryId
                showRecordingOverlay = true
            }
            .onAppear {
                dataStore.initializeDefaultsIfNeeded()
            }
        }
    }

    private func extractCategoryId(from url: URL) -> UUID? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == "categoryId" }?
            .value
            .flatMap(UUID.init(uuidString:))
    }
}
