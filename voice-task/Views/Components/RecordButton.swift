import SwiftUI

struct RecordButton: View {
    let isRecording: Bool
    let color: Color
    let action: () -> Void

    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            if isRecording {
                Circle()
                    .fill(Color(hex: "#E74C3C").opacity(0.2))
                    .frame(width: 70, height: 70)
                    .scaleEffect(pulseScale)
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: pulseScale
                    )
                    .onAppear { pulseScale = 1.3 }
                    .onDisappear { pulseScale = 1.0 }
            }

            Button(action: action) {
                Circle()
                    .fill(isRecording ? Color(hex: "#E74C3C") : color)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            }
        }
    }
}
