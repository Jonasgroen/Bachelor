import Foundation

class Reading {
    
    var date: Date
    var maxFrequency: Int
    var leftEar: Bool
    var maxDB: Int
    
    init(maxDB: Int, frequency: Int, leftEar: Bool) {
        self.maxFrequency = frequency
        self.date = Date.init()
        self.leftEar = leftEar
        self.maxDB = maxDB
    }
}
