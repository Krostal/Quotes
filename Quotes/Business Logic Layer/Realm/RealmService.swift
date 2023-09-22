import Foundation
import RealmSwift

protocol RealmServicProtocol {
    func saveQuote(_ quote: Quote) -> Bool
    func fetchQuotes() -> [Quote]
    func delete(usingID id: String) -> Bool
    func update(_ quote: Quote) -> Bool
}

final class RealmService: RealmServicProtocol {
    
    func saveQuote(_ quote: Quote) -> Bool {
        do {
            let realm = try Realm()
            
            let handler: () -> Void = {
                realm.create(
                    QuoteRealmModel.self,
                    value: quote.keyedValues
                )}
            
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
    
    func delete(usingID id: String) -> Bool {
        do {
            let realm = try Realm()
            
            let objects = realm.objects(QuoteRealmModel.self)
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
    
    func update(_ quote: Quote) -> Bool {
        do {
            let realm = try Realm()
            
            let quoteRealmModel = QuoteRealmModel(quote: quote)
            let handler: () -> Void = {
                realm.add(quoteRealmModel, update: .modified)
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


