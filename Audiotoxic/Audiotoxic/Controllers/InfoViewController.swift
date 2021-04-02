import UIKit

class Section {
    let title: String
    let description: String
    var isExpanded: Bool = false
    
    init(title: String, description: String, isExpanded: Bool = false) {
        self.title = title
        self.description = description
        self.isExpanded = isExpanded
    }
}

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
        
        sections = [
            Section(title: "Otoxic Drugs", description: "description"),
            Section(title: "Diagnosis and this app", description: "description"),
            Section(title: "Treatment", description: "description"),
            Section(title: "How Audiotoxic works", description: "description"),
            Section(title: "Read more about Ototoxicity", description: "description")
        ]
        
        scrollView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = scrollView.bounds
        //setText()

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
    
    func setText(){
        openingText.textContainer.lineBreakMode = NSLineBreakMode.byCharWrapping
        openingText.text =
        "According to Neil Bauman, Ph.D., “Ototoxic drugs are those medications that can cause ototoxic (ear damaging) side effects to your ears. Such drugs can cause hearing loss, hyperacusis, tinnitus, and other phantom sounds and a whole host of balance problems.” Although physician-prescribed medications may effectively treat a specific health condition, they can also damage the fragile hair cells in the inner ear, impacting a person’s ability to hear and balance (source).\n\n" +
            
        "Tinnitus, of course, does not afflict everyone who takes drugs. Even if a drug’s description lists tinnitus as a side effect, it does not mean that you will develop tinnitus if you take it. Some people do. Many don’t. However, it is still important to learn the side effects of any drug you take. That way, you can react accordingly if you do develop a side effect. To evaluate your level of tinnitus or hyperacusis, take our tinnitus and hyperacusis impact surveys. According to Neil Bauman, Ph.D., “Ototoxic drugs are those medications that can cause ototoxic (ear damaging) side effects to your ears. Such drugs can cause hearing loss, hyperacusis, tinnitus, and other phantom sounds and a whole host of balance problems.” Although physician-prescribed medications may effectively treat a specific health condition, they can also damage the fragile hair cells in the inner ear, impacting a person’s ability to hear and balance (source).\n\n" +

        "Tinnitus, of course, does not afflict everyone who takes drugs. Even if a drug’s description lists tinnitus as a side effect, it does not mean that you will develop tinnitus if you take it. Some people do. Many don’t. However, it is still important to learn the side effects of any drug you take. That way, you can react accordingly if you do develop a side effect. To evaluate your level of tinnitus or hyperacusis, take our tinnitus and hyperacusis impact surveys.  List of Ototoxic Medications\n\n" +
            
        "When a medication is ototoxic, it has a toxic effect on the ear or its nerve supply. Depending on the medication and dosage, the effects of ototoxic medications can be temporary or permanent. The American Tinnitus Association (ATA) recognizes that the following ototoxic drugs may cause more permanent tinnitus symptoms:\n\n" +

        "Non-Steroidal Anti-Inflammatory Drugs (NSAIDs), including aspirin, ibuprofen, and naproxen\n" +
        "Certain antibiotics, including aminoglycosides\n" +
        "Certain cancer medications\n" +
        "Water pills and diuretics\n" +
        "Quinine-based medications\n" +
        "Other common medications that can cause ototoxicity include the following:\n" +

        "Certain anticonvulsants\n" +
        "Tricyclic antidepressants\n" +
        "Anti-anxiety medications\n" +
        "Antimalarial medications\n" +
        "Blood pressure controlling medications\n" +
        "Allergy medications\n" +
        "Chemotherapy drugs, including cisplatin\n" +
        "Review the ATA’s full, specific list of ototoxic medications for more information. We recommend you use this list as a resource in your discussions with your health care professional.\n\n" +

        "What to Do If You Suspect a New Drug Is Causing Tinnitus" +
        "When you are aware of which drugs can damage your ears via ototoxicity, you are in a position to help protect them. As a drug accumulates in your body, the risk for ototoxicity increases. If you experience tinnitus after you begin taking a new medication, contact your prescribing physician. You should not stop taking any medication without first consulting with your healthcare provider. The risks of stopping a medication may far exceed any potential benefit.\n\n" +

        "In addition, if you already have tinnitus, let your physician know before he or she prescribes a new medication, as effective alternatives to ototoxic drugs may be available. If you are worried about tinnitus as a side effect of your medications, again, please consult your subscribing physician or pharmacist. In addition, remember that just because your doctor prescribes one of these medications, that doesn’t mean you will lose your sense of hearing or develop tinnitus; experiences with ototoxic medications vary from person to person (source).\n\n" +


        "If you have taken any drugs from our list of ototoxic medications and are now suffering from tinnitus, contact Sound Relief Hearing Center today to explore your treatment options. Our audiologists specialize in tinnitus treatment, and we have provided life-changing relief to thousands of patients through FDA-approved tinnitus treatments."
        
        
    }
    
}
