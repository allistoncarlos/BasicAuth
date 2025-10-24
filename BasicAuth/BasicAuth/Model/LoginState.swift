enum LoginState: Equatable {
    case idle
    case loading
    case success(LoginResponse)
    case error(LoginError)
}
