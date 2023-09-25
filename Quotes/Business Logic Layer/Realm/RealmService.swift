import Foundation
import RealmSwift

protocol RealmServicProtocol {
    func saveQuote(_ quote: Quote) -> Bool
    func fetchQuotes() -> [Quote]
    func deleteQuote(usingID id: String) -> Bool
    func removeAllQuotes() -> Bool
    func fetchCategories() -> [String]
    func removeAllQuotesInCategory(category: String) -> Bool
}

final class RealmService: RealmServicProtocol {
    
    func saveQuote(_ quote: Quote) -> Bool {
        do {
            let realm = try Realm()
            
            let handler: () -> Void = {
                if let existingQuote = realm.object(ofType: QuoteRealmModel.self, forPrimaryKey: quote.id) {
                    realm.delete(existingQuote)
                    realm.create(
                        QuoteRealmModel.self,
                        value: quote.keyedValues
                    )
                } else {
                    realm.create(
                        QuoteRealmModel.self,
                        value: quote.keyedValues
                    )}
            }
            
            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func fetchQuotes() -> [Quote] {
        do {
            let realm = try Realm()
            
            let objects = realm.objects(QuoteRealmModel.self)
            
            let quotes = objects.map { Quote(quoteRealmModel: $0) }
            
            return Array(quotes)
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteQuote(usingID id: String) -> Bool {
        do {
            let realm = try Realm()
            
            let objects = realm.objects(QuoteRealmModel.self).filter{ $0.id == id }
            let handler: () -> Void = {
                realm.delete(objects)
            }
            
            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func removeAllQuotes() -> Bool {
        do {
            let realm = try Realm()
            
            if realm.isInWriteTransaction {
                realm.deleteAll()
            } else {
                try realm.write {
                    realm.deleteAll()
                }
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func fetchCategories() -> [String] {
        do {
            let realm = try Realm()
            let categories = realm.objects(QuoteRealmModel.self).compactMap { $0.category }
            return Array(categories)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func removeAllQuotesInCategory(category: String) -> Bool {
        do {
            let realm = try Realm()
            
            let objects = realm.objects(QuoteRealmModel.self).filter{ $0.category == category }
            let handler: () -> Void = {
                realm.delete(objects)
                print(objects)
            }
            
            if realm.isInWriteTransaction {
                handler()
            } else {
                try realm.write {
                    handler()
                }
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}


