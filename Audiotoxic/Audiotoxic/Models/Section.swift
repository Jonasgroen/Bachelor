
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
