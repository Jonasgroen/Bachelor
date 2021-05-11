

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBOutlet weak var TabBarItems: UITabBar!
    
    let profile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile.loadProfile()
        if(profile.name == ""){
            if (TabBarItems?.items != nil) {
                let tabBarControllerItems = TabBarItems.items
                if let tabArray = tabBarControllerItems {
                    tabArray[1].isEnabled = false
                    tabArray[3].isEnabled = false
                }
            }
        }
    }
}
