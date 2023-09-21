import Foundation

struct Quote: Decodable {
    let text: String
    let date: Date
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case text = "value"
        case date
        case category
    }
}
