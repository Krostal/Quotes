
import UIKit

final class RandomQuoteLoaderViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    private var randomQuote: Quote?
    
    let interactor: QuoteInteractorProtocol = QuoteInteractor(realmService: RealmService(), dataService: DataService())
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        fetchRandomQuote()
        print("Кнопку нажал")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchRandomQuote() {
        interactor.fetchQuoteFromNetwork { result in
            switch result {
            case .success(let quote):
                
                DispatchQueue.main.async {
                    self.textLabel.text = quote.text
                }
            case .failure(let error):
                
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
}
