//
//  LoginError.swift
//  BasicAuth
//
//  Created by Alliston Aleixo on 24/10/25.
//


import Combine
import SwiftUI

enum RegisterError: Error, Equatable {
    case genericError
}

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var state: RegisterState = .idle
    
    private var authService: AuthService = AuthService()

    func register(
        firstName: String,
        lastName: String,
        username: String,
        password: String
    ) async {
        state = .loading

        do {
            try await authService.register(
                firstName: firstName,
                lastName: lastName,
                username: username,
                password: password
            )
            
            try await authService.login(
                username: username,
                password: password
            )

            state = .success
        } catch {
            print("Erro desconhecido: \(error.localizedDescription)")
            state = .error(.genericError)
        }
    }

    private var cancellable = Set<AnyCancellable>()
}
