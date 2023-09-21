
import UIKit

final class RandomQuoteLoaderViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    private var randomQuote: Quote?
    var randomQuoteText: String?
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        fetchRandomQuote()
        print("Кнопку нажал")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func fetchRandomQuote() {
        
        DataService<Quote>.fetchData(from: "https://api.chucknorris.io/jokes/random") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let quote):
                
                DispatchQueue.main.async {
                    self.textLabel.text = quote.text
                }
                // пока сохраняю в пременную, потом заменить на Realm
                self.randomQuoteText = quote.text
                
            case .failure(let error):
                print("❌ Network Error:", error.description)
            }
        }
    }
    
}
