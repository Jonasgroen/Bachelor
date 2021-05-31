import Foundation

class SectionManager{
    
    var sections = [Section]()
    let stringTable = "InternalLocalizedStrings"
    
    func loadSections(){
        
        sections = [
            Section(title: NSLocalizedString("section.title.how-to-use-this-app", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.how-to-use-this-app", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.ototoxic-drug", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.ototoxic-drug", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.signs-symptoms",
                    tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.signs-symptoms", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.diagnosis", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.diagnosis", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.treatment", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.treatment", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.audiotoxic-app", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.audiotoxic-app", tableName: stringTable, comment: "")),
            Section(title: NSLocalizedString("section.title.read-more", tableName: stringTable, comment: ""),
                    description: NSLocalizedString("section.description.read-more", tableName: stringTable, comment: ""))
        ]
    }
}
