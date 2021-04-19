import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openingText: UITextView!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    private let stringTable = "InternalLocalizedStrings"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSections()
        
        scrollView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = scrollView.bounds
        
        openingText.text = NSLocalizedString("info.opening-text", tableName: stringTable,
            comment: "")

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if(section.isExpanded){
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        if(indexPath.row == 0){
            cell.textLabel?.text = sections[indexPath.section].title
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        } else {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.textLabel?.text = sections[indexPath.section].description
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 0){
            sections[indexPath.section].isExpanded = !sections[indexPath.section].isExpanded
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    func loadSections(){
        
        sections = [
            Section(title: NSLocalizedString("section.title.ototoxic-drug", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.ototoxic-drug", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.signs-symptoms",
                    tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.signs-symptoms", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.diagnosis", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.diagnosis", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.treatment", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.treatment", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.audiotoxic-app", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.audiotoxic-app", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.read-more", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.read-more", tableName: stringTable, comment: ""))
        ]
    }
    
}

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
