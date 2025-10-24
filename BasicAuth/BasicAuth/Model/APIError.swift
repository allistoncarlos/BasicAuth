import Foundation

struct APIError: Codable, LocalizedError {
    let message: String
    
    var errorDescription: String? {
        return message
    }
}
