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

final class RealmService {
        
    static let encryptionKey: Data = {
        if KeychainService.shared.isEncryptionKeyExist {
            if let existingKey = KeychainService.shared.getEncryptionKey() {
                return existingKey
            }
        } else {
            var key = Data(count: 64)
            _ = key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
                SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            }
            KeychainService.shared.saveEncryptionKey(key)
            return key
        }
        fatalError("Problem with get or create encryptionKey")
    }()

    
    private var config: Realm.Configuration?
    
    init() {
        self.config = Realm.Configuration(encryptionKey: Self.encryptionKey)
    }
}

extension RealmService: RealmServicProtocol {
    
    func saveQuote(_ quote: Quote) -> Bool {
        guard let config = config else { return false }
        
        do {
            let realm = try Realm(configuration: config)
            
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
        
        guard let config = config else { return [] }
        
        do {
            let realm = try Realm(configuration: config)
            
            let objects = realm.objects(QuoteRealmModel.self)
            
            let quotes = objects.map { Quote(quoteRealmModel: $0) }
            
            return Array(quotes)
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteQuote(usingID id: String) -> Bool {
        
        guard let config = config else { return false }
        
        do {
            let realm = try Realm(configuration: config)
            
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
        
        guard let config = config else { return false }
        
        do {
            let realm = try Realm(configuration: config)
            
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
        
        guard let config = config else { return [] }
        
        do {
            let realm = try Realm(configuration: config)
            let categories = realm.objects(QuoteRealmModel.self).compactMap { $0.category }
            return Array(categories)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func removeAllQuotesInCategory(category: String) -> Bool {
        
        guard let config = config else { return false }
        
        do {
            let realm = try Realm(configuration: config)
            
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

