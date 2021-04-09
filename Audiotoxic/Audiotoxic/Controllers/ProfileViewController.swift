import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var profileSaved: UILabel!
    
    var gender = true
    let vc = TabBarViewController()
    let profile = Profile()
    
    @IBAction func save(_ sender: Any) {

        if (name.text != "") {
            profileSaved.alpha = 1
            profileSaved.text = ""
            if sex.selectedSegmentIndex == 0 {
                gender = true
            } else {
                gender = false
            }
            
            profile.name = self.name.text!
            profile.sex = gender
            profile.dateOfBirth = self.datePick.date.addingTimeInterval(7200.0)
            profile.saveProfile()
            //Shows the text profilesaved for 2 seconds!
            UIView.animate(withDuration: 2) {
                self.profileSaved.text = "Profile saved!"
                self.profileSaved.alpha = 0
            }
            
        }
        if let tabBarItem = self.tabBarController?.tabBar.items?[1] {
            tabBarItem.isEnabled = true
        }
        if let tabBarItem = self.tabBarController?.tabBar.items?[3] {
            tabBarItem.isEnabled = true
        }
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var index = 0
        
        datePick.maximumDate = Date.init()
            
        profile.loadProfile()
        name.text = profile.name
        datePick.date = profile.dateOfBirth
        if(profile.sex){
            index = 0
        } else {
            index = 1
        }
        sex.selectedSegmentIndex = index
    }
    
    func printUserDefaults(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation()
        { print("\(key) = \(value) \n") }
    }
    func clearUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize() }
}
