//
//  ViewHandler.swift
//  Audiotoxic
//
//  Created by Jonas Sigerseth Grøn on 14/12/2020.
//  Copyright © 2020 sdu.dk. All rights reserved.
//

import Foundation


class ViewHandler {
    
    func handleViewChecker(ViewIdentifier: String, Disview: UIViewController) -> Bool {
        let distinatedView = self.storyboard?.instantiateViewController(withIdentifier: ViewIdentifier) as! View

        self.navigationController.pushViewController(Disview, animated: true)
    }
    


}
