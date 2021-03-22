//
//  TabBarViewController.swift
//  Audiotoxic
//
//  Created by Jonas Sigerseth Grøn on 14/12/2020.
//  Copyright © 2020 sdu.dk. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    @IBOutlet weak var TabBarItems: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.object(forKey: "name")==nil){
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
