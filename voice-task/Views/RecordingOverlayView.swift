import SwiftUI

struct RecordingOverlayView: View {
    @Environment(SharedDataStore.self) private var dataStore

    let categoryId: UUID
    let onDismiss: () -> Void

    @State private var speechManager = SpeechRecognitionManager()
    @State private var isRecording = false
    @State private var hasStarted = false

    var body: some View {
        ZStack {
            background
            recordingPanel
        }
        .ignoresSafeArea()
        .onAppear {
            guard !hasStarted else { return }
            hasStarted = true
            startRecording()
        }
    }

    // MARK: - Subviews

    private var background: some View {
        Color.black.opacity(0.85)
            .onTapGesture { cancelAndDismiss() }
    }

    private var recordingPanel: some View {
        VStack(spacing: DesignMetrics.Spacing.lg) {
            Text(isRecording ? "録音中..." : "録音準備完了")
                .font(.system(size: DesignMetrics.FontSize.headline, weight: .semibold))
                .foregroundStyle(Color.textPrimary)

            if !speechManager.recognizedText.isEmpty {
                Text(speechManager.recognizedText)
                    .font(.system(size: DesignMetrics.FontSize.body))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxHeight: 100)
            }

            RecordButton(isRecording: isRecording, color: dataStore.categoryColor(for: categoryId)) {
                toggleRecording()
            }

            Button("キャンセル") { cancelAndDismiss() }
                .font(.system(size: DesignMetrics.FontSize.body))
                .foregroundStyle(Color.textSecondary)
        }
        .padding(DesignMetrics.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: DesignMetrics.CornerRadius.overlay)
                .fill(.white)
                .shadow(color: .black.opacity(DesignMetrics.Opacity.overlayShadow), radius: 20, y: 10)
        )
        .padding(DesignMetrics.Spacing.xl)
    }

    // MARK: - Actions

    private func toggleRecording() {
        if isRecording {
            speechManager.stopRecording()
            isRecording = false
            dataStore.addTaskFromSpeech(speechManager.recognizedText, categoryId: categoryId)
            onDismiss()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        speechManager.requestPermissions { authorized in
            guard authorized else { return }
            speechManager.startRecording()
            isRecording = true
        }
    }

    private func cancelAndDismiss() {
        if isRecording { speechManager.stopRecording() }
        onDismiss()
    }
}
