import SwiftUI

struct TaskListView: View {
    @Environment(SharedDataStore.self) private var dataStore
    let category: Category

    @State private var isRecording = false
    @State private var speechManager = SpeechRecognitionManager()

    private var tasks: [TaskItem] {
        dataStore.tasksForCategory(category.id)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(tasks) { task in
                    TaskRow(task: task) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            dataStore.toggleTask(task.id)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        dataStore.deleteTask(tasks[index].id)
                    }
                }
            }
            .listStyle(.plain)
            .overlay {
                if tasks.isEmpty {
                    ContentUnavailableView {
                        Label("タスクがありません", systemImage: "tray")
                    } description: {
                        Text("録音ボタンをタップして\n音声でタスクを追加しましょう")
                    }
                }
            }

            RecordButton(
                isRecording: isRecording,
                color: Color(hex: category.colorHex)
            ) {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            }
            .padding(24)
        }
        .background(Color(hex: "#F8F9FA"))
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func startRecording() {
        speechManager.startRecording()
        isRecording = true
    }

    private func stopRecording() {
        speechManager.stopRecording()
        isRecording = false

        let text = speechManager.recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let task = TaskItem(text: text, categoryId: category.id)
        dataStore.addTask(task)
        speechManager.recognizedText = ""
    }
}
