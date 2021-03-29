import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var profileSaved: UILabel!
    
    var gender = true
    let vc = TabBarViewController()
    
    @IBAction func save(_ sender: Any) {
        if (name.text != "") {
            profileSaved.alpha = 1
            profileSaved.text = ""
            if sex.selectedSegmentIndex == 0 {
                gender = true
            } else {
                gender = false
            }
            let profile = Profile()
            profile.name = self.name.text!
            profile.sex = gender
            profile.dateOfBirth = self.datePick.date
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
        openDatabse()
        super.viewDidLoad()
        
       //printUserDefaults()
        //clearUserDefaults()

        datePick.maximumDate = Date.init()
        
        if(UserDefaults.standard.object(forKey: "name") != nil){
            var index = 0
            
            let profile = Profile()
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
    }
    
    func printUserDefaults(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation()
        { print("\(key) = \(value) \n") }
    }
    func clearUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize() }


    // MARK: Variables declearations
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!

        // MARK: View Controller life cycle methods

        // MARK: Methods to Open, Store and Fetch data
        func openDatabse()
        {
            context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            saveData(UserDBObj:newUser)
        }

        func saveData(UserDBObj:NSManagedObject)
        {
            
            UserDBObj.setValue("jonas", forKey: "name")

            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }

            fetchData()
            
        }

        func fetchData()
        {
            print("Fetching Data..")
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    let name = data.value(forKey: "name") as! String
                    print("name is : "+name)
                }
            } catch {
                print("Fetching data Failed")
            }
        }
    }

