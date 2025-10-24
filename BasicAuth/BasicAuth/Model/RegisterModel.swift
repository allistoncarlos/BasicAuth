struct RegisterRequest: Codable {
    let firstName: String
    let lastName: String
    let username: String
    let password: String
}

struct RegisterResponse: Codable {
    let username: String
}
