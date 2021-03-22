import Foundation

class Reading {
    
    var date: Date
    var maxFrequency: Int
    
    init(frequency: Int) {
        maxFrequency = frequency
        date = Date.init()
    }
}
