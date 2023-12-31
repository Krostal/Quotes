
import UIKit

final class QuotesListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension QuotesListCellTableViewCell: Configurable {
    func configure(with model: Quote) {
        dateLabel.text = model.date
        categoryLabel.text = model.category
        quoteLabel.text = "\"\(model.text)\""
    }
}
