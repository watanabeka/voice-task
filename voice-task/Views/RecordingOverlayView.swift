import SwiftUI

struct RecordingOverlayView: View {
    @Environment(SharedDataStore.self) private var dataStore
    @Environment(\.dismiss) private var dismiss

    let categoryId: UUID

    @State private var speechManager = SpeechRecognitionManager()
    @State private var isRecording = false
    @State private var hasStarted = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    cancelAndDismiss()
                }

            VStack(spacing: 24) {
                Text(isRecording ? "録音中..." : "録音準備完了")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color(hex: "#2C3E50"))

                if !speechManager.recognizedText.isEmpty {
                    Text(speechManager.recognizedText)
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "#2C3E50"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .frame(maxHeight: 100)
                }

                RecordButton(
                    isRecording: isRecording,
                    color: categoryColor
                ) {
                    if isRecording {
                        stopAndSave()
                    } else {
                        startRecording()
                    }
                }

                Button("キャンセル") {
                    cancelAndDismiss()
                }
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "#95A5A6"))
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
            )
            .padding(32)
        }
        .onAppear {
            if !hasStarted {
                hasStarted = true
                startRecording()
            }
        }
    }

    private var categoryColor: Color {
        if let category = dataStore.categories.first(where: { $0.id == categoryId }) {
            return Color(hex: category.colorHex)
        }
        return Color(hex: "#4A90D9")
    }

    private func startRecording() {
        speechManager.requestPermissions { authorized in
            if authorized {
                speechManager.startRecording()
                isRecording = true
            }
        }
    }

    private func stopAndSave() {
        speechManager.stopRecording()
        isRecording = false

        let text = speechManager.recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !text.isEmpty {
            let task = TaskItem(text: text, categoryId: categoryId)
            dataStore.addTask(task)
        }
        dismiss()
    }

    private func cancelAndDismiss() {
        if isRecording {
            speechManager.stopRecording()
            isRecording = false
        }
        dismiss()
    }
}
