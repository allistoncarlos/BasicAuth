import Combine
import SwiftUI

enum LoginError: Error, Equatable {
    case invalidUsernameOrPassword
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var state: LoginState = .idle
    
    private var authService: AuthService = AuthService()

    func login(username: String, password: String) async {
        state = .loading

        do {
            try await authService.login(username: username, password: password)

            state = .success
        } catch let error as NetworkError {
            let errorMessage: String
            
            switch error {
            case .apiError(let message):
                errorMessage = "Erro de API: \(message)"
            case .unauthorized:
                errorMessage = "Credenciais inválidas. Verifique usuário e senha."
            default:
                errorMessage = "Erro ao fazer login. Tente novamente."
            }
            
            print(errorMessage)
        } catch {
            print("Erro desconhecido: \(error.localizedDescription)")
            state = .error(.invalidUsernameOrPassword)
        }
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

extension LoginViewModel {
    @MainActor
    func contentView() -> some View {
        return ContentView()
    }
}
