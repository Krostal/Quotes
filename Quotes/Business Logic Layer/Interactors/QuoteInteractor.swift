
//import Foundation
//
//protocol QuoteRepository {
//    func fetchRandomQuote(completion: @escaping (Result<String, Error>) -> Void)
//}
//
//final class QuoteInteractor {
//    
//    private let quoteRepository: QuoteRepository
//        
//    init(quoteRepository: QuoteRepository) {
//        self.quoteRepository = quoteRepository
//    }
//    
//    func fetchAndSaveRandomQuote() {
//        quoteRepository.fetchRandomQuote { result in
//            switch result {
//            case .success(let quoteText):
//                let quoteObject = QuoteObject(text: quoteText, category: nil)
//                RealmManager.shared.saveQuote(quoteObject)
//            case .failure(let error):
//                print("Failed to fetch quote: \(error)")
//            }
//        }
//    }
//    
//}
