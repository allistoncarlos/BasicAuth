enum LoginState: Equatable {
    case idle
    case loading
    case success
    case error(LoginError)
}
