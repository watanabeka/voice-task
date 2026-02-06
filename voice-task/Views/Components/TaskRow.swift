import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void

    private var stateColor: Color { task.isDone ? .textDone : .textPrimary }

    var body: some View {
        HStack(spacing: DesignMetrics.Spacing.sm) {
            Button(action: onToggle) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: DesignMetrics.FontSize.icon))
                    .foregroundStyle(stateColor)
            }
            .buttonStyle(.plain)

            Text(task.text)
                .font(.system(size: DesignMetrics.FontSize.body))
                .foregroundStyle(stateColor)
                .strikethrough(task.isDone, color: .textDone)
                .lineLimit(2)

            Spacer()

            Text(task.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.system(size: DesignMetrics.FontSize.caption))
                .foregroundStyle(.textSecondary)
        }
        .padding(.vertical, DesignMetrics.Spacing.xxs)
        .opacity(task.isDone ? DesignMetrics.Opacity.doneTask : 1.0)
    }
}
