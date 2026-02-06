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
            taskList
            RecordButton(isRecording: isRecording, color: Color(hex: category.colorHex)) {
                toggleRecording()
            }
            .padding(DesignMetrics.Spacing.lg)
        }
        .background(Color.appBackground)
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var taskList: some View {
        List {
            ForEach(tasks) { task in
                TaskRow(task: task) {
                    withAnimation(.easeInOut(duration: DesignMetrics.Animation.toggleDuration)) {
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
    }

    private func toggleRecording() {
        if isRecording {
            speechManager.stopRecording()
            isRecording = false
            dataStore.addTaskFromSpeech(speechManager.recognizedText, categoryId: category.id)
            speechManager.recognizedText = ""
        } else {
            speechManager.startRecording()
            isRecording = true
        }
    }
}
