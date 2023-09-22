
import UIKit

final class CategoryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let interactor: QuoteInteractorProtocol = QuoteInteractor(realmService: RealmService(), dataService: DataService())
    
    var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = interactor.getCategoriesFromRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategoryAndUpdateTable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails",
           let categoryDetailViewController = segue.destination as? CategoryDetailViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let selectedCategory = categories[selectedIndexPath.row]
                categoryDetailViewController.category = selectedCategory
            }
        }
    }
    
    private func fetchCategoryAndUpdateTable() {
        categories = interactor.getCategoriesFromRealm()
        tableView.reloadData()
    }
}

extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        var content = categoryCell.defaultContentConfiguration()
        
        content.text = category
        
        content.textProperties.color = .systemPurple
        content.image = UIImage(systemName: "book")
        categoryCell.contentConfiguration = content
        
        return categoryCell
    }
}
