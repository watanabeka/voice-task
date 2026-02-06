import SwiftUI

struct RecordButton: View {
    let isRecording: Bool
    let color: Color
    let action: () -> Void

    @State private var pulseScale: CGFloat = 1.0

    private var buttonColor: Color { isRecording ? .recordingRed : color }
    private var iconName: String { isRecording ? "stop.fill" : "mic.fill" }

    var body: some View {
        ZStack {
            if isRecording {
                pulseCircle
            }
            mainButton
        }
    }

    private var pulseCircle: some View {
        Circle()
            .fill(Color.recordingRed.opacity(DesignMetrics.Opacity.pulseFill))
            .frame(width: DesignMetrics.Size.recordPulse, height: DesignMetrics.Size.recordPulse)
            .scaleEffect(pulseScale)
            .animation(
                .easeInOut(duration: DesignMetrics.Animation.pulseDuration)
                    .repeatForever(autoreverses: true),
                value: pulseScale
            )
            .onAppear { pulseScale = DesignMetrics.Animation.pulseScale }
            .onDisappear { pulseScale = 1.0 }
    }

    private var mainButton: some View {
        Button(action: action) {
            Circle()
                .fill(buttonColor)
                .frame(width: DesignMetrics.Size.recordButton, height: DesignMetrics.Size.recordButton)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: DesignMetrics.FontSize.icon))
                        .foregroundStyle(.white)
                )
                .appShadow(DesignMetrics.buttonShadow)
        }
    }
}
