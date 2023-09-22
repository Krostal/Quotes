
import UIKit

final class QuoteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let interactor: QuoteInteractorProtocol = QuoteInteractor(realmService: RealmService(), dataService: DataService())
    
    var quotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quotes = interactor.getQuotesFromRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchQuotesAndUpdateTable()
    }
    
    private func fetchQuotesAndUpdateTable() {
        quotes = interactor.getQuotesFromRealm()
        tableView.reloadData()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Внимание!", message: "Вы действительно хотите безвозвратно удалить все цитаты?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            let success = self.interactor.removeAllQuotesFromRealm()
            if success {
                self.fetchQuotesAndUpdateTable()
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
    

