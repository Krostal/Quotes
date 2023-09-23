
import UIKit

class CategoryDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let interactor: QuoteInteractorProtocol = QuoteInteractor(realmService: RealmService(), dataService: DataService())
        
    var category: String = ""
    var quotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quotes = interactor.getQuotesForCategory(category)
        navigationItem.title = category
    }
    
    private func fetchQuotesAndUpdateTable() {
        quotes = interactor.getQuotesForCategory(category)
        tableView.reloadData()
    }
    
    @IBAction private func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Внимание!", message: "Вы действительно хотите безвозвратно удалить все цитаты из этой категории?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            let success = self.interactor.removeAllQuotesInCategoryFromRealm(category: self.category)
            if success {
                self.fetchQuotesAndUpdateTable()
                self.navigationController?.popViewController(animated: true)
            } else {
                let errorAlert = UIAlertController(title: "Ошибка", message: "Не удалось удалить цитаты", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let quote = quotes[indexPath.row]
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "удалить") { [weak self] _,_,_ in
                guard let self else { return }
                if self.interactor.removeSelectedQuoteFromRealm(withID: quote.id) {
                    self.tableView.performBatchUpdates {
                        self.quotes.remove(at: indexPath.row)
                        self.tableView.deleteRows(
                            at: [indexPath],
                            with: .right)
                    }
                }
            }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemPurple
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}
