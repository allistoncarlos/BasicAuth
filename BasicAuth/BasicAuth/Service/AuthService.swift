import Foundation
import Combine

// Exemplo de um serviço de autenticação
@MainActor
class AuthService: ObservableObject {
    // Singleton para acesso compartilhado onde necessário
    static let shared = AuthService()

    // Publicado para que as Views possam reagir à mudança de estado
    @Published var isAuthenticated: Bool = false
    private let networkService = NetworkService.shared
    @Published var authToken: String? = nil // O token JWT

    // Placeholder para as funções de autenticação
    func login(username: String, password: String) async throws {
        let requestBody = LoginRequest(username: username, password: password)
        let response: LoginResponse = try await networkService.request(
            endpoint: "User/login",
            method: "POST",
            body: requestBody
        )
        
        // Como a classe é @MainActor, podemos atualizar o estado diretamente
        self.authToken = response.accessToken
        self.isAuthenticated = true
        // TODO: Salvar token no Keychain
    }
    
    func register(firstName: String, lastName: String, username: String, password: String) async throws {
        let requestBody = RegisterRequest(firstName: firstName, lastName: lastName, username: username, password: password)
        // Assumindo que a API retorna um token ou um status de sucesso que pode ser ignorado.
        let _: RegisterResponse = try await networkService.request(
            endpoint: "User/register",
            method: "POST",
            body: requestBody
        )
        // Tentar logar automaticamente após o registro
        try await login(username: username, password: password)
    }
    
    func logout() {
        // TODO: Limpar token do Keychain
        self.authToken = nil
        self.isAuthenticated = false
    }

    // Função para carregar o token salvo no Keychain ao iniciar o app
    func loadAuthToken() {
        // Lógica para carregar token do Keychain
        // Se o token for válido:
        // self.authToken = loadedToken
        // self.isAuthenticated = true
    }

    // Funções para autenticação social (Apple/Google) serão adicionadas
}
