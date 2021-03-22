import UIKit
import Charts
import TinyConstraints

class ResultDetailsViewController: UIViewController {
    
    var testDate: String!
    var yValues: [ChartDataEntry] = []
    let profile = Profile()
    
    @IBOutlet weak var dateOfTest: UILabel!
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        
        let yAxis = chartView.leftAxis
        
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        yAxis.labelPosition = .outsideChart
        yAxis.axisMaximum = 20000
        yAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelRotationAngle = 90
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .black
        chartView.xAxis.axisLineColor = .black
        
        chartView.animate(xAxisDuration: 2.5)
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        createData()
        lineChartView.xAxis.valueFormatter = DateAxisValueFormatter()
        lineChartView.xAxis.centerAxisLabelsEnabled = true
        lineChartView.xAxis.granularity = 1.0
        
        
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .none
        
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        
        setData()
        
        //dateOfTest.text = "Date of test: " + testDate
        // Do any additional setup after loading the view.
    }
    
    func chartValueSelected(_chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight ) {
        //print(entry)
    }
    
    func createData(){
        profile.loadProfile()
        let secondsPerDay = 24.0 * 3600.0
        for item in profile.results {
            //print(item.date)
            yValues.append(ChartDataEntry(x: item.date.timeIntervalSince1970/secondsPerDay, y: Double(item.maxFrequency)))
        }
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "frequency")
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
        
    }
}
