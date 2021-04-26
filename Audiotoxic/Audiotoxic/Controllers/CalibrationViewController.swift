//
//  CalibrationViewController.swift
//  Audiotoxic
//
//  Created by Rasmus Bødker on 26/04/2021.
//  Copyright © 2021 sdu.dk. All rights reserved.
//

import UIKit

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
        
    }
    
    @IBAction func playAtInputDB(_ sender: Any) {
        //Play sound with the given dB level
        let leftEar = earControl.selectedSegmentIndex == 0 ? true : false
        let selectedFrequency = getSelectedFrequency()
        let maxDB = maxDBText.text
        let inputDB = inputDBText.text
        
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
    
    private func getSelectedFrequency() -> Int {
        var selectedFrequency = frequencies[frequencyPicker.selectedRow(inComponent: 0)]
        selectedFrequency.removeLast()
        selectedFrequency.removeLast()
        return Int.init(selectedFrequency)!
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
