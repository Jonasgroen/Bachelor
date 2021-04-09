import Foundation
import CoreData
import UIKit

class Profile {
    
    var name: String = ""
    var dateOfBirth: Date = Date.init()
    var sex: Bool = true
    var numberOfReadings = 0
    var results: [Reading] = []
    let formatter = DateFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
    
    
    init() {
        
        
    }
    
    
    func saveProfile() {
        deleteData()
        openDatabase()
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        formatter.dateFormat = "dd/MM/yyyy"
        numberOfReadings = results.count
        
        newUser.setValue(name, forKey: "name")
        newUser.setValue(dateOfBirth, forKey: "dateOfBirth")
        newUser.setValue(sex, forKey: "gender")
        newUser.setValue(numberOfReadings, forKey: "numberOfReadings")
        var readingArray: [String] = []
        var readingData: [String] = []
        
        for reading in results {
            readingData = [reading.date.description, reading.maxFrequency.description]
            readingArray.append(contentsOf: readingData)
        }
        
        let arrayAsString: String = readingArray.description
        newUser.setValue(arrayAsString, forKey: "data")
        print(arrayAsString)
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
    }
    
    func openDatabase()
    {
        context = appDelegate.persistentContainer.viewContext
    }
    
    func deleteData(){
        // Create Fetch Request
        openDatabase()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Could not delete data from core data..")
        }
    }
    
    func loadProfile()
    {
        print("Fetching Data..")
        openDatabase()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if result.isNotEmpty {
                for data in result as! [NSManagedObject] {
                    name = data.value(forKey: "name") as! String
                    sex = data.value(forKey: "gender") as! Bool
                    dateOfBirth = data.value(forKey: "dateOfBirth") as! Date
                    results.removeAll()
                    if let myData = data.value(forKey: "data") as? String
                    {
                        print(myData)
                        let stringAsData = myData.data(using: String.Encoding.utf16)
                        let readingArray: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
                        for i in stride(from: 0, to: readingArray.count, by: 2) {
                            let dateFormatterGet = DateFormatter()
                            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"

                            let date: Date? = dateFormatterGet.date(from: readingArray[i]) as Date?
                            let freq = Int(readingArray[i+1])
                            print(date!)
                            print(freq ?? 0)
                            let newReading = Reading(frequency: freq!)
                            newReading.date = date!
                            results.append(newReading)
                        }
                    }
                    print("name is : " + name)
                    print(sex)
                    print(dateOfBirth)
                }
            }
        } catch {
            print("Fetching data Failed")
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
