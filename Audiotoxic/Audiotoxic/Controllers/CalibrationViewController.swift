

import UIKit
import AudioKit

class CalibrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var inputDBText: UITextField!
    @IBOutlet weak var maxDBText: UITextField!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var earControl: UISegmentedControl!
    
    let frequencies = ["10000Hz", "12500Hz", "14000Hz", "16000Hz"]
    let osciliator = AKOscillator(waveform: AKTable(.sine))
    let ampManager = AmpManager()
    
    var panner: AKPanner!
    
    let queue = DispatchQueue(label: "calibration-queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        self.frequencyPicker.delegate = self
        self.frequencyPicker.dataSource = self
    }
    
    @IBAction func playAtMax(_ sender: Any) {
        //Plays at phone max to find the maxDB for a given frequency
        let leftEar = earControl.selectedSegmentIndex == 0 ? true : false
        let selectedFrequency = getSelectedFrequency()
        playSound(freq: selectedFrequency, isLeftEar: leftEar, dB: 0, maxDB: 0)
    }
    
    @IBAction func playAtInputDB(_ sender: Any) {
        //Play sound with the given dB level using the recorded max dB
        let leftEar = earControl.selectedSegmentIndex == 0 ? true : false
        let selectedFrequency = getSelectedFrequency()
        
        
       // let maxDBValue = Double(maxDBText.text!)!
       // let inputDBValue = Double(inputDBText.text!)!

        if let maxDBValue = Double(maxDBText.text!), let inputDBValue = Double(inputDBText.text!){
            playSound(freq: selectedFrequency, isLeftEar: leftEar, dB: inputDBValue, maxDB: maxDBValue)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return frequencies[row]
        }
    
    private func getSelectedFrequency() -> Double {
        var selectedFrequency = frequencies[frequencyPicker.selectedRow(inComponent: 0)]
        selectedFrequency.removeLast()
        selectedFrequency.removeLast()
        return Double.init(selectedFrequency)!
    }
    
    private func playSound(freq: Double, isLeftEar: Bool, dB: Double, maxDB: Double){
        queue.async {
            let calculatedAmp = self.ampManager.calculateAmplitudeCalibration(inputDB: dB, maxDB: maxDB)
            self.osciliator.frequency = freq
            self.osciliator.amplitude = maxDB > 0 ? calculatedAmp : 1
            self.osciliator.rampDuration = 1
        
        do{
            try AKManager.stop()
        }
        catch{
            print("AudioKit could not stop")
        }
        
            self.panner = AKPanner(self.osciliator, pan: (isLeftEar) ? -1 : 1)
            AudioKit.AKManager.output = self.panner //Remember to set output as panner
            
        do{
            try AudioKit.AKManager.start()
        }catch{
            print("could not start AudioKit.")
        }

            self.panner.start()
            self.osciliator.start()
        sleep(5)
            self.osciliator.amplitude = 0
        }
    }
    }

