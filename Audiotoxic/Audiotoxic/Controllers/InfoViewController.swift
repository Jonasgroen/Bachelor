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
