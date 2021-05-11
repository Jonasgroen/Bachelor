//
//  CalibrationViewController.swift
//  Audiotoxic
//
//  Created by Rasmus Bødker on 26/04/2021.
//  Copyright © 2021 sdu.dk. All rights reserved.
//

import UIKit
import AudioKit

class CalibrationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var inputDBText: UITextField!
    @IBOutlet weak var maxDBText: UITextField!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var earControl: UISegmentedControl!
    
    let frequencies = ["10000Hz", "12500Hz", "14000Hz", "16000Hz"]
    let osciliator = AKOscillator(waveform: AKTable(.sine))
    
    var panner: AKPanner!
    
    let queue = DispatchQueue(label: "calibration-queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        self.frequencyPicker.delegate = self
        self.frequencyPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playAtMax(_ sender: Any) {
        //Just play sound at max volume on selected ear
        let leftEar = earControl.selectedSegmentIndex == 0 ? true : false
        let selectedFrequency = getSelectedFrequency()
        playSound(freq: selectedFrequency, isLeftEar: leftEar, dB: 0, maxDB: 0)
    }
    
    @IBAction func playAtInputDB(_ sender: Any) {
        //Play sound with the given dB level
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
            let calculatedAmp = self.calculateAmplitude(maxDB: maxDB, inputDB: dB)
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
    
    private func calculateAmplitude(maxDB: Double, inputDB: Double) -> Double{
        /*
         Math.pow(10,(dbRSPL-phoneMaxDBOutput.get(testFreqNo))/20);
         Forklaring: ((DBHvadViVilAfspille - MaxDBOutputForFrekvens) / 20)^10
         */
        let calculatedAmp = pow(10, (inputDB - maxDB) / 20)
        return calculatedAmp
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
