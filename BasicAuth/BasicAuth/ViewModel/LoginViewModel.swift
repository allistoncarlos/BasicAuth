import Combine
import SwiftUI

enum LoginError: Error, Equatable {
    case invalidUsernameOrPassword
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var state: LoginState = .idle

    func login(username: String, password: String) async {
        state = .loading

        // TODO: Implement login service
    }

    private var cancellable = Set<AnyCancellable>()

    private func saveToken(response: LoginResponse?) {
        if let session = response,
           let id = session.id,
           let accessToken = session.accessToken,
           let refreshToken = session.refreshToken,
           let expiresIn = session.expiresIn {
            let dateFormatter = ISO8601DateFormatter()

            let formattedExpiresIn = dateFormatter.string(from: expiresIn)

            // TODO: Implement Keychain token (and other properties) saving

            DispatchQueue.main.async {
                let message = [
                    id,
                    accessToken,
                    refreshToken,
                    formattedExpiresIn
                ]
            }
        } else {
            // TODO: Implement keychain clear logic
        }
    }
}
