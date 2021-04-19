import Foundation

class Reading {
    
    var date: Date
    var maxFrequency: Int
    var leftEar: Bool
    
    init(frequency: Int, leftEar: Bool) {
        self.maxFrequency = frequency
        self.date = Date.init()
        self.leftEar = leftEar
    }
}
