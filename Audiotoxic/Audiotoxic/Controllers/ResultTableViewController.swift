import UIKit

class ResultTableViewController: UITableViewController {
    
    
    var idCount: Int!
    var selectedReading: Reading!
    var profile = Profile()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profile.loadProfile()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedReading = Reading(maxDB: 0, frequency: 0, leftEar: true)
        idCount = profile.results.count + 1
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return profile.results.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reading = profile.results[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultTableViewCell
        let formatter = DateFormatter()
        
        // Configure the cell...
        //idCount = idCount - 1
        formatter.dateFormat = "dd/MM/yyyy"
        cell.resultDate.text = NSLocalizedString("result.date", tableName: "InternalLocalizedStrings", comment: "") + formatter.string(from: reading.date)
        cell.freqID.text = NSLocalizedString("result.frequency", tableName: "InternalLocalizedStrings", comment: "") + String(reading.maxFrequency)
            + " dB: " + String(reading.maxDB)
        
        if(reading.leftEar){
            cell.resultID.text = NSLocalizedString("result.details.left-ear", tableName: "InternalLocalizedStrings", comment: "")
        }
        else {
            cell.resultID.text = NSLocalizedString("result.details.right-ear", tableName: "InternalLocalizedStrings", comment: "")
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResultDetailsViewController {
            let vc = segue.destination as? ResultDetailsViewController
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            vc?.testDate = formatter.string(from: selectedReading.date)
        }
    }
}
