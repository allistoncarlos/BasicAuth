enum RegisterState: Equatable {
    case idle
    case loading
    case success
    case error(RegisterError)
}
