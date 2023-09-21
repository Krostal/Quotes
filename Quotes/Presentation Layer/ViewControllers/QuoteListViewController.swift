
import UIKit

final class QuoteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var quotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension QuoteListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let quoteCell = tableView.dequeueReusableCell(withIdentifier: "QuotesListCellTableViewCell", for: indexPath) as? QuotesListCellTableViewCell else {
            return UITableViewCell()
        }
        let quote = quotes[indexPath.row]
        
        quoteCell.configure(with: quote)
        
        return quoteCell
    }
    
    
}
