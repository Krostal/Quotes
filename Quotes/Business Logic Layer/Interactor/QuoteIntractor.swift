
import Foundation

protocol QuoteInteractorProtocol {
    func fetchQuoteFromNetwork(completion: @escaping (Result<Quote, Error>) -> Void)
    func saveQuoteToRealm(_ quote: Quote, completion: @escaping (Result<Void, Error>) -> Void)
    func getQuotesFromRealm() -> [Quote]
}


class QuoteInteractor: QuoteInteractorProtocol {
    
    private enum QuoteInteractorError: Error {
        case saveFailed
        
        var description: String {
            switch self {
            case .saveFailed:
                return "❌ Ошибка сохранения цитаты в Realm"
            }
        }
    }
    
    let realmService: RealmServicProtocol
    let dataService: DataService<Quote>
    
    init(realmService: RealmServicProtocol, dataService: DataService<Quote>) {
        self.realmService = realmService
        self.dataService = dataService
    }
    
    func fetchQuoteFromNetwork(completion: @escaping (Result<Quote, Error>) -> Void) {
        dataService.fetchData(from: "https://api.chucknorris.io/jokes/random") { result in
            switch result {
            case .success(let quote):
                self.saveQuoteToRealm(quote) { result in
                    switch result {
                    case .success:
                        completion(.success(quote))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveQuoteToRealm(_ quote: Quote, completion: @escaping (Result<Void, Error>) -> Void) {
        let success = realmService.saveQuote(quote)
        if success {
            completion(.success(()))
        } else {
            print(QuoteInteractorError.saveFailed.description)
            completion(.failure(QuoteInteractorError.saveFailed))
        }
    }
    
    func getQuotesFromRealm() -> [Quote] {
        return realmService.fetchQuotes()
    }
}



