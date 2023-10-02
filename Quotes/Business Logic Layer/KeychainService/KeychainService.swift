import KeychainAccess
import Foundation

protocol KeychainServiceProtocol {
    var isEncryptionKeyExist: Bool { get }
    func saveEncryptionKey(_ encryptionKey: Data)
    func deleteEncryptionKey()
    func getEncryptionKey() -> Data?
}

final class KeychainService: KeychainServiceProtocol {
    
    static let shared = KeychainService()
    
    private init() {}
    
    private let keychain = Keychain(service: "com.krostal.Quotes")
    private let myKey = "QuotesRealmEncryptionKey"
    
    var isEncryptionKeyExist: Bool {
        do {
            let existingKey = try keychain.getData(myKey)
            return (existingKey != nil)
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func saveEncryptionKey(_ encryptionKey: Data) {
        do {
            try keychain.set(encryptionKey, key: myKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteEncryptionKey() {
        do {
            try keychain.remove(myKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getEncryptionKey() -> Data? {
        do {
            return try keychain.getData(myKey)
        } catch {
            print("Error retrieving encryption key from Keychain: \(error.localizedDescription)")
            return nil
        }
    }
    
}
