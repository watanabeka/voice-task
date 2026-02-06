import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(task.isDone ? Color(hex: "#BDC3C7") : Color(hex: "#2C3E50"))
            }
            .buttonStyle(.plain)

            Text(task.text)
                .font(.system(size: 15))
                .foregroundStyle(task.isDone ? Color(hex: "#BDC3C7") : Color(hex: "#2C3E50"))
                .strikethrough(task.isDone, color: Color(hex: "#BDC3C7"))
                .lineLimit(2)

            Spacer()

            Text(task.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: "#95A5A6"))
        }
        .padding(.vertical, 4)
        .opacity(task.isDone ? 0.6 : 1.0)
    }
}
