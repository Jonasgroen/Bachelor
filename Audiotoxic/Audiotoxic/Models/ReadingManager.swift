import Foundation

class ReadingManager {
    
    var readings: [Reading]
    let dateFormatter = DateFormatter()
    
    init() {
        readings = []
    }
    
    
    func setReadings(){
        var testDict = Dictionary<Int, Bool>()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        /*testDict.updateValue(false, forKey: 16000)
        readings.append(Reading(date: dateFormatter.date(from: "01-09-2020")!, results: testDict))
        testDict.removeAll()
        testDict.updateValue(false, forKey: 14000)
        readings.append(Reading(date: dateFormatter.date(from: "01-10-2020")!, results: testDict))
        testDict.removeAll()
        testDict.updateValue(false, forKey: 12000)
        readings.append(Reading(date: dateFormatter.date(from: "01-11-2020")!, results: testDict))
        testDict.removeAll()
        testDict.updateValue(false, forKey: 10000)
        readings.append(Reading(date: dateFormatter.date(from: "01-12-2020")!, results: testDict))
        testDict.removeAll()
        testDict.updateValue(false, forKey: 8000)
        readings.append(Reading(date: dateFormatter.date(from: "01-01-2021")!, results: testDict))
        testDict.removeAll()*/
    }
}
