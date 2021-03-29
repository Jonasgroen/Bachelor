import Foundation

class Profile {
    
    var name: String = ""
    var dateOfBirth: Date = Date.init()
    var sex: Bool = true
    var numberOfReadings = 0
    var results: [Reading] = []
    let formatter = DateFormatter()
    
    
    init() {
    }
    
    func saveProfile() {
        formatter.dateFormat = "dd/MM/yyyy"
        numberOfReadings = results.count
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(dateOfBirth, forKey: "dateOfBirth")
        UserDefaults.standard.set(sex, forKey: "sex")
        UserDefaults.standard.set(numberOfReadings, forKey: "number")
        var index: Int = 0
        for reading in results {
            index = index + 1
            UserDefaults.standard.set(formatter.string(from: reading.date), forKey: "date" + String(index))
            UserDefaults.standard.set(reading.maxFrequency, forKey: "freq" + String(index))
        }
    }
    
    func loadProfile()  {
        //clearUserDefaults()
        formatter.dateFormat = "dd/MM/yyyy"
        if (gotUser(key: "name")){
            self.name = UserDefaults.standard.string(forKey: "name")!
            
        }
        if (gotUser(key: "dateOfBirth")){
            self.dateOfBirth = UserDefaults.standard.value(forKey: "dateOfBirth") as! Date
        }
        if (gotUser(key: "sex")){
            self.sex = UserDefaults.standard.bool(forKey: "sex")
            
        }
        if (gotUser(key: "number")) {
            numberOfReadings = UserDefaults.standard.integer(forKey: "number")
        }
        if (numberOfReadings > 0) {
            results.removeAll()
            for index in 1...numberOfReadings {
                //var frequency: Int = 0
                //var date: Date = Date.init()
                
                let date = UserDefaults.standard.object(forKey: "date" + String(index)) as! String
                let frequency = UserDefaults.standard.integer(forKey: "freq" + String(index))
                let reading = Reading(frequency: frequency)
                reading.date = formatter.date(from: date)!
                results.append(reading)
            }
        }
    }
    
    func okToSave(date: Date, freq: Int) -> Bool{
        var max = 0
        formatter.dateFormat = "dd/MM/yyyy"
        for item in self.results where (formatter.string(from: item.date) == formatter.string(from: date)) {
            if item.maxFrequency > max {
                max = item.maxFrequency
            }
        }
        if (freq > max) {
            self.results.removeAll(where: {formatter.string(from: $0.date) == formatter.string(from: date)})
            saveProfile()
            return true
        } else {
            return false
        }
    }
    
    func gotUser(key: String) -> Bool {
        return UserDefaults.standard.value(forKey: key) != nil
    }
    
    func printUserDefaults(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
        
    }
    
    func clearUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
