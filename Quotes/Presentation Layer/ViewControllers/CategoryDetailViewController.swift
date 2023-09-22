
import UIKit

class CategoryDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let interactor: QuoteInteractorProtocol = QuoteInteractor(realmService: RealmService(), dataService: DataService())
        
    var category: String = ""
    var quotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchQuotesAndUpdateTable()
        navigationItem.title = category
    }
    
    private func fetchQuotesAndUpdateTable() {
        quotes = interactor.getQuotesForCategory(category)
        tableView.reloadData()
    }
    
}


extension CategoryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailCell", for: indexPath) as? CategoryDetailTableViewCell else {
            return UITableViewCell()
        }
        
        let quote = quotes[indexPath.row]
        
        cell.configure(with: quote)
        
        return cell
    }
    
    
}
