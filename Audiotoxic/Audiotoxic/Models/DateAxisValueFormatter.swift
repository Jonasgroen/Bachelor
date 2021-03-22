import Foundation
import Charts

class DateAxisValueFormatter : NSObject, IAxisValueFormatter
{
    let dateFormatter = DateFormatter()
    let secondsPerDay = Double(24 * 3600)
    
    override init()
    {
        super.init()
        dateFormatter.dateFormat = "dd MMM"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        let date = Date(timeIntervalSince1970: value * secondsPerDay)
        return dateFormatter.string(from: date)
    }
}
