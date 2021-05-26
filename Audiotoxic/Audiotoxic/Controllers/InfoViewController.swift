import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openingText: UITextView!
    
    let profile = Profile()
    
    let sectionManager = SectionManager()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    //private var sections = [Section]()
    
    private let stringTable = "InternalLocalizedStrings"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionManager.loadSections()
        
        scrollView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = scrollView.bounds
        
        openingText.text = NSLocalizedString("info.opening-text", tableName: stringTable,
            comment: "")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionManager.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sectionManager.sections[section]
        
        if(section.isExpanded){
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        if(indexPath.row == 0){
            cell.textLabel?.text = sectionManager.sections[indexPath.section].title
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.textLabel?.text = sectionManager.sections[indexPath.section].description
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 0){
            sectionManager.sections[indexPath.section].isExpanded = !sectionManager.sections[indexPath.section].isExpanded
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
}

//Extension to enable hyperlinks but this requires the text to be TextFields instead of labels
//which is why we are not using it at the moment, as that would present more issues.
extension UITextView {

  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .left
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
    }

    self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
    ]
    self.attributedText = attributedOriginalText
  }
}
