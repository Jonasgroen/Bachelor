//
//  Section.swift
//  Audiotoxic
//
//  Created by Rasmus Bødker on 12/04/2021.
//  Copyright © 2021 sdu.dk. All rights reserved.
//

import Foundation

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
