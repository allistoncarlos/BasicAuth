import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case apiError(String)
    case unauthorized
    case decodingError(Error)
    case unknown(Error)
}

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "<API_ENDPOINT_HERE>"
    
    // Variável para armazenar o token JWT
    var authToken: String? {
        return AuthService.shared.authToken
    }

    private init() {}

    func request<T: Decodable>(endpoint: String, method: String = "GET", body: Encodable? = nil, requiresAuth: Bool = false) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Adicionar token de autenticação se necessário
        if requiresAuth {
            guard let token = authToken else {
                throw NetworkError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("Decoding Error: \(error)")
                throw NetworkError.decodingError(error)
            }
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            // Tenta decodificar o erro da API, se houver um formato padrão
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                throw NetworkError.apiError(apiError.message)
            } else {
                throw NetworkError.apiError("Erro do cliente (\(httpResponse.statusCode))")
            }
        case 500...599:
            throw NetworkError.apiError("Erro do servidor (\(httpResponse.statusCode))")
        default:
            throw NetworkError.apiError("Erro desconhecido (\(httpResponse.statusCode))")
        }
    }
}
