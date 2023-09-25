
import Foundation
import RealmSwift

final class QuoteRealmModel: Object {
    @objc dynamic var id: String?
    @objc dynamic var text: String?
    @objc dynamic var category: String?
    @objc dynamic var date: String?
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(quote: Quote) {
        self.init()
        id = quote.id
        text = quote.text
        category = quote.category
        date = quote.date
    }
    
}
