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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSections()
        
        scrollView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = scrollView.bounds

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
        } else {
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
            Section(title: "What is an Ototoxic drug?",
                    description: "Certain medications can damage the ear, resulting in hearing loss, ringing in the ear, or balance disorders. These drugs are considered ototoxic. There are more than 200 known ototoxic medications (prescription and over-the-counter) on the market today. These include medicines used to treat serious infections, cancer, and heart disease."),
            Section(title: "Signs and Symptoms",
                    description: "description"),
            Section(title: "Diagnosis",
                    description: "description"),
            Section(title: "Treatment",
                    description: "description"),
            Section(title: "How the Audiotoxic app can help you",
                    description: "description"),
            Section(title: "Read more about Ototoxicity",
                    description: "description")
        ]
    }
    
}
