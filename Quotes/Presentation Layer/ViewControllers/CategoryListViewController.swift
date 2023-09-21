
import UIKit

final class CategoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        content.text = category.name
        
        content.textProperties.color = .systemPurple
        content.image = UIImage(systemName: "book")
        categoryCell.contentConfiguration = content
        
        return categoryCell
    }
}
