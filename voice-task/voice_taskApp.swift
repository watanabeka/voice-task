import SwiftUI

@main
struct VoiceFusenApp: App {
    @State private var dataStore = SharedDataStore()
    @State private var deepLinkHandler = DeepLinkHandler()
    @State private var showRecordingOverlay = false
    @State private var recordingCategoryId: UUID?

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(dataStore)
                .environment(deepLinkHandler)
                .onOpenURL { url in
                    deepLinkHandler.handle(url: url)
                }
                .onChange(of: deepLinkHandler.pendingRecordingCategoryId) { _, newValue in
                    if let categoryId = newValue {
                        recordingCategoryId = categoryId
                        showRecordingOverlay = true
                        deepLinkHandler.pendingRecordingCategoryId = nil
                    }
                }
                .fullScreenCover(isPresented: $showRecordingOverlay) {
                    if let categoryId = recordingCategoryId {
                        RecordingOverlayView(categoryId: categoryId)
                            .environment(dataStore)
                    }
                }
                .onAppear {
                    dataStore.initializeDefaultsIfNeeded()
                }
        }
    }
}
