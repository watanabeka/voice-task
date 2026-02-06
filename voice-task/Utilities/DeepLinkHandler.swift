import Foundation

@Observable
final class DeepLinkHandler: @unchecked Sendable {
    var pendingRecordingCategoryId: UUID?

    func handle(url: URL) {
        guard url.scheme == AppConstants.urlScheme,
              url.host == "record" else { return }

        pendingRecordingCategoryId = extractCategoryId(from: url)
    }

    private func extractCategoryId(from url: URL) -> UUID? {
        URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == "categoryId" }?
            .value
            .flatMap(UUID.init(uuidString:))
    }
}
