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
        let refreshAlert = UIAlertController(title: "Warning", message: "All data will be lost if you proceed", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //Handle Ok Logic here
            if (self.name.text != "") {
                self.profileSaved.alpha = 1
                self.profileSaved.text = ""
                if self.sex.selectedSegmentIndex == 0 {
                    self.gender = true
                } else {
                    self.gender = false
                }
                
                self.profile.name = self.name.text!
                self.profile.sex = self.gender
                // adding 7200 second to get the right timeZone.
                self.profile.dateOfBirth = self.datePick.date.addingTimeInterval(7200.0)
                self.profile.saveProfile()
                //Shows the text profilesaved for 2 seconds!
                UIView.animate(withDuration: 2) {
                    self.profileSaved.text = "Profile saved!"
                    self.profileSaved.alpha = 0
                }
                if let tabBarItem = self.tabBarController?.tabBar.items?[1] {
                    tabBarItem.isEnabled = true
                }
                if let tabBarItem = self.tabBarController?.tabBar.items?[3] {
                    tabBarItem.isEnabled = true
                }
            }
            
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              //Handle Cancel Logic here
            UIView.animate(withDuration: 2) {
                self.profileSaved.text = "Profile was not saved!"
                self.profileSaved.alpha = 0
            }
        }))

        present(refreshAlert, animated: true, completion: nil)

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

