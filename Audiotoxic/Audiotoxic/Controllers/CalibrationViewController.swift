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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.frequencyPicker.delegate = self
        self.frequencyPicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playAtMax(_ sender: Any) {
        //Just play sound at max volume on selected ear
        let leftEar = earControl.selectedSegmentIndex == 0 ? true : false
        let selectedFrequency = getSelectedFrequency()
        playSound(freq: selectedFrequency, isLeftEar: leftEar, dB: 100)
    }
    
    @IBAction func playAtInputDB(_ sender: Any) {
        //Play sound with the given dB level
        let leftEar = earControl.selectedSegmentIndex == 0 ? true : false
        let selectedFrequency = getSelectedFrequency()
        let maxDBValue = Double(maxDBText.text!)!
        let inputDBValue = Double(inputDBText.text!)!
        let calculatedDB = calculateDB(maxDB: maxDBValue, inputDB: inputDBValue)
        playSound(freq: selectedFrequency, isLeftEar: leftEar, dB: calculatedDB)
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
    
    private func playSound(freq: Double, isLeftEar: Bool, dB: Double){
        let oscillator = AKOscillator()
        oscillator.frequency = freq
        oscillator.amplitude = dB
        oscillator.rampDuration = 0.25
        let panner = AKPanner(oscillator, pan: (isLeftEar) ? -1 : 1)
        AudioKit.AKManager.output = panner //Remember to set output as panner
        do{
            try AudioKit.AKManager.start()
        }catch{
            print("could not start AudioKit.")
        }
        
        panner.start()
        oscillator.start()
        sleep(5)
            do{
                try AKManager.stop()}
            catch{
                print("AudioKit could not stop")
            }
    }
    
    private func calculateDB(maxDB: Double, inputDB: Double) -> Double{
        return 0
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
