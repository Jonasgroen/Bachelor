import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var freqID: UILabel!
    @IBOutlet weak var resultID: UILabel!
    @IBOutlet weak var resultDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
