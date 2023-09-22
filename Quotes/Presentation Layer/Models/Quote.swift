import Foundation

struct Quote: Decodable {
    let id: String
    let text: String
    let category: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text = "value"
        case categories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        text = try container.decode(String.self, forKey: .text)
        
        let categories = try container.decode([String].self, forKey: .categories)
        if let firstCategory = categories.first, !firstCategory.isEmpty {
            category = firstCategory.capitalized
        } else {
            category = "Без категории"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        date = dateFormatter.string(from: Date())
    }
    
    init(quoteRealmModel: QuoteRealmModel) {
        id = quoteRealmModel.id ?? ""
        text = quoteRealmModel.text ?? ""
        category = quoteRealmModel.category ?? ""
        date = quoteRealmModel.date ?? ""
    }
    
    var keyedValues: [String: Any] {
        [
            "id": id,
            "text": text,
            "category": category,
            "date": date
        ]
    }
    
}
