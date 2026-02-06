import Foundation

@Observable
final class DeepLinkHandler {
    var pendingRecordingCategoryId: UUID?

    func handle(url: URL) {
        guard url.scheme == AppConstants.urlScheme else { return }

        if url.host == "record" {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let categoryIdString = components?.queryItems?.first(where: { $0.name == "categoryId" })?.value,
               let categoryId = UUID(uuidString: categoryIdString) {
                pendingRecordingCategoryId = categoryId
            }
        }
    }
}
