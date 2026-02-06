import Foundation
import Speech
import AVFoundation

@Observable
final class SpeechRecognitionManager: @unchecked Sendable {
    var recognizedText: String = ""
    var isRecording: Bool = false

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // MARK: - Permissions

    func requestPermissions(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else {
                completion(false)
                return
            }
            AVAudioApplication.requestRecordPermission { allowed in
                completion(allowed)
            }
        }
    }

    // MARK: - Recording

    func startRecording() {
        resetRecognition()

        guard configureAudioSession(),
              let request = createRecognitionRequest() else { return }

        recognitionRequest = request
        startRecognitionTask(with: request)
        startAudioEngine(with: request)
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
    }

    // MARK: - Private helpers

    private func resetRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognizedText = ""
    }

    private func configureAudioSession() -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            return true
        } catch {
            print("Audio session setup failed: \(error)")
            return false
        }
    }

    private func createRecognitionRequest() -> SFSpeechAudioBufferRecognitionRequest? {
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        if speechRecognizer?.supportsOnDeviceRecognition == true {
            request.requiresOnDeviceRecognition = true
        }
        return request
    }

    private func startRecognitionTask(with request: SFSpeechAudioBufferRecognitionRequest) {
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
            if let result {
                self.recognizedText = result.bestTranscription.formattedString
            }
            if error != nil || result?.isFinal == true {
                self.tearDownAudioPipeline()
            }
        }
    }

    private func startAudioEngine(with request: SFSpeechAudioBufferRecognitionRequest) {
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
        } catch {
            print("Audio engine start failed: \(error)")
        }
    }

    private func tearDownAudioPipeline() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
    }
}
