import UIKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openingText: UITextView!
    
    let profile = Profile()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections = [Section]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (profile.name == "") {
            print("hey")
            
        }
            
        
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
            Section(title: "What is an Ototoxic drug?",
                    description: "Certain medications can damage the ear, resulting in hearing loss, ringing in the ear, or balance disorders. These drugs are considered ototoxic. There are more than 200 known ototoxic medications (prescription and over-the-counter) on the market today. These include medicines used to treat serious infections, cancer, and heart disease."),
            Section(title: "Signs and Symptoms",
                    description: "When you are taking ototoxic drugs, you should be aware of any changes in your hearing. The first signs of ototoxicity is usually ringing in the ears (tinnitus) and/or high frequency hearing loss. The high frequencies are not common to experience so you must be aware your hearing ability with these frequencies by yourself. If you keep track of your hearing in the high frequencies, you may be able to prevent hearing loss in the lower frequencies, which is much more common in your life. Lastly, you can also experience a loss of balance or a feeling of unsteadiness when standing."),
            Section(title: "Diagnosis",
                    description: "The problem with diagnosing Ototoxicity is that it is gradually getting worse over time and it begins very subtely. Therefore it is important to be aware of whether or not your medication is Ototoxic. Your physician should recommend regular hearing tests to make sure that you catch hearing damage early. This way physicians can also discontinue or reduce the medication dose to ensure no further hearing damage is made."),
            Section(title: "Treatment",
                    description: "There are no current treatments to reverse the effects of ototoxicity. That is why it is so important to detect early on. Patients who suffer from permanent hearing damage may elect to use hearing aids or implants."),
            Section(title: "How the Audiotoxic app can help you",
                    description: "As mentioned in the above sections, the effects of Ototoxicity are subtle and irreversible. Therefore it is very important to detect any potential damage early on. The Audiotoxic app can be your regular hearing test you can use to keep track of your hearing. The app can potentially prevent permanent hearing loss and it makes hearings tests more accessible."),
            Section(title: "Read more about Ototoxicity",
                    description: "You can read more about Ototoxicity on the following pages:" +
                    "\n\nmedical-dictionary.thefreedictionary.com" +
                    "\n\nasha.org" +
                    "\n\nen.wikipedia.org")
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
