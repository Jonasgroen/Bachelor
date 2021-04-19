import UIKit
import Charts
import TinyConstraints

class ResultDetailsViewController: UIViewController {
    
    var testDate: String!
    var yValuesLeft: [ChartDataEntry] = []
    var yValuesRight: [ChartDataEntry] = []
    var xAxis: [String] = []
    let profile = Profile()
    var isLandscape = false
    
    @IBOutlet weak var dateOfTest: UILabel!
    var lineChartView: LineChartView = LineChartView()
    

    func createGraph(){
        lineChartView = {
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
            chartView.xAxis.enabled = true
            chartView.xAxis.labelRotationAngle = 90
            chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
            chartView.xAxis.setLabelCount(6, force: false)
            chartView.xAxis.labelTextColor = .black
            chartView.xAxis.axisLineColor = .black
            
            chartView.animate(xAxisDuration: 2.5)
            return chartView
        }()
    }
    
    func drawGraph(){
        lineChartView.removeFromSuperview()
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        if isLandscape {
            lineChartView.width(700)
            lineChartView.height(230)
        }else{
            lineChartView.width(to: view)
            lineChartView.heightToWidth(of: view)
        }
        
        
        createData()
        lineChartView.xAxis.valueFormatter = DateAxisValueFormatter()
        lineChartView.xAxis.centerAxisLabelsEnabled = true
        lineChartView.xAxis.granularity = 1.0
        
        
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .none
        
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        
        setData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLandscape = landscapeOrNah()
        createGraph()
        drawGraph()
        
        
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
            if item.leftEar == true {
                yValuesLeft.append(ChartDataEntry(x: round(item.date.timeIntervalSince1970/secondsPerDay), y: Double(item.maxFrequency)))
                print(yValuesLeft)
            } else {
                yValuesRight.append(ChartDataEntry(x: round(item.date.timeIntervalSince1970/secondsPerDay), y: Double(item.maxFrequency)))
                print(yValuesRight)
            }
        }
    }
    
    func setData() {
        var allLineChartDataSets: [LineChartDataSet] = [LineChartDataSet]()
        let leftSet = LineChartDataSet(entries: yValuesLeft, label: "Left ear - frequency")
        allLineChartDataSets.append(leftSet)
        let rightSet = LineChartDataSet(entries: yValuesRight, label: "Right ear - frequency")
        rightSet.setColor(UIColor.systemRed)
        rightSet.setCircleColor(UIColor.systemRed)
        allLineChartDataSets.append(rightSet)
        let lineChartData = LineChartData(dataSets: allLineChartDataSets)
        lineChartView.data = lineChartData
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        isLandscape = landscapeOrNah()
        drawGraph()
    }
    
    func landscapeOrNah() -> Bool{
        var landscape: Bool
        if UIDevice.current.orientation.isLandscape {
            landscape = true
        } else {
            landscape = false
        }
        return landscape
    }
}
