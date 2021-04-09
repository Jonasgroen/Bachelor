import Foundation

class Reading {
    
    var date: Date
    var maxFrequency: Int
    
    init(frequency: Int) {
        self.maxFrequency = frequency
        self.date = Date.init()
    }
}
