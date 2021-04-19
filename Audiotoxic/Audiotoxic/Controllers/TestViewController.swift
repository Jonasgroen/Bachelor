import UIKit
import AudioKit
import AVFoundation

class TestViewController: UIViewController {
    
    @IBOutlet weak var LabelInTest: UILabel!
    @IBOutlet weak var testButton: UIButton!
    
    let osciliator = AKOscillator()
    var isTestRunning = false
    var isAudioOn = false
    var currentFreq: Int!
    var currentdB: Int!
    var maxFreq = 0
    var dBOfFinalReading = 0
    var profile = Profile()
    var panner: AKPanner!
    
    
    let queue = DispatchQueue(label: "audio-queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile.loadProfile()
        AudioKit.AKManager.output = osciliator
        do {
            try AudioKit.AKManager.start()
        } catch {
            print("Can't start AudioKit AKManager")
        }
        do {
            try AudioKit.AKManager.stop()
        } catch {
            print("Can't start AudioKit AKManager")
        }
        // Do any additional setup after loading the view.
    }
    
    /*@IBAction func soundButton(_ sender: Any) {
     if (isTestRunning) {
     if (isAudioOn) {
     maxFreq = currentFreq
     dBOfFinalReading = currentdB
     }
     } else {
     isTestRunning = true
     LabelInTest.text = "Press the red button when you hear the sound."
     testButton.setImage(UIImage(named: "stopBtn"), for: .normal)
     queue.async {
     self.waitRandom()
     self.createTone(freq: 8000)
     self.waitRandom()
     self.createTone(freq: 10000)
     self.waitRandom()
     self.createTone(freq: 12500)
     self.waitRandom()
     self.createTone(freq: 14000)
     self.waitRandom()
     self.createTone(freq: 16000)
     self.isTestRunning = false
     let reading = Reading(frequency: self.maxFreq)
     print(reading.maxFrequency)
     print(reading.date)
     if self.profile.okToSave(date: reading.date, freq: reading.maxFrequency){
     self.profile.results.append(reading)
     self.profile.saveProfile()
     }
     }
     }
     }*/
    
    func createTone(freq: Double){
        currentFreq = Int(freq)
        isAudioOn = true
        osciliator.frequency = freq
        osciliator.rampDuration = 0.25
        osciliator.start()
        sleep(2)
        osciliator.stop()
        isAudioOn = false
        DispatchQueue.main.async {
            if (!self.isTestRunning) {
                self.LabelInTest.text = "Press the start button to begin the test!"
                self.testButton.setImage(UIImage(named: "startBtn"), for: .normal)
            }
        }
        
    }
    
    func waitRandom(){
        sleep(UInt32.random(in: 2...5))
    }
    
    @IBAction func soundButton(_ sender: Any) {
        print(isAudioOn)
        if (isTestRunning) {
            if (isAudioOn) {
                print(maxFreq)
                maxFreq = currentFreq
                dBOfFinalReading = currentdB
            }
        } else {
            isTestRunning = true
            LabelInTest.text = "Press the red button when you hear the sound."
            testButton.setImage(UIImage(named: "stopBtn"), for: .normal)
            improvedAlgorithm(leftEar: true)
            //Make sure that the first test has finished
            //improvedAlgorithm(leftEar: false)
        }
    }
    
    func improvedAlgorithm(leftEar: Bool){
        queue.async {
            self.waitRandom()
            self.createTone(freq: 10000, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            self.createTone(freq: 10000, dB: 80, isLeftEar: leftEar)
            self.waitRandom()
            self.createTone(freq: 12500, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            self.createTone(freq: 12500, dB: 80, isLeftEar: leftEar)
            self.waitRandom()
            self.createTone(freq: 14000, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            self.createTone(freq: 14000, dB: 80, isLeftEar: leftEar)
            self.waitRandom()
            self.createTone(freq: 16000, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            self.createTone(freq: 16000, dB: 80, isLeftEar: leftEar)
            self.isTestRunning = false
            let reading = Reading(frequency: self.maxFreq, leftEar: leftEar)
            print(reading.maxFrequency)
            print(reading.date)
            if self.profile.okToSave(date: reading.date, freq: reading.maxFrequency, leftEar: leftEar){
                self.profile.results.append(reading)
                self.profile.saveProfile()
            }
        }
    }
    
    func createTone(freq: Double, dB: Int, isLeftEar: Bool){
        currentFreq = Int(freq)
        currentdB = dB
        isAudioOn = true
        osciliator.frequency = freq
        osciliator.amplitude = calculateVolume(dB: dB)
        osciliator.rampDuration = 0.25
        panner = AKPanner(osciliator, pan: (isLeftEar) ? -1 : 1)
        AudioKit.AKManager.output = panner //Remember to set output as panner
        do{
            try AudioKit.AKManager.start()
        }catch{
            print("could not start AudioKit.")
        }
        
        panner.start()
        osciliator.start()
        sleep(2)
            do{
                try AKManager.stop()}
            catch{
                print("AudioKit could not stop")
            }
        
        
        //osciliator.stop()
        isAudioOn = false
        DispatchQueue.main.async { //Hvorfor er det her? Er det når testen slutter at den går tilbage ved sidste tryk?
            if (!self.isTestRunning) {
                self.LabelInTest.text = "Press the start button to begin the test!"
                self.testButton.setImage(UIImage(named: "startBtn"), for: .normal)
            }
        }
    }
    
    func calculateVolume(dB: Int) -> Double{
        /*
         Math.pow(10,(dbRSPL-phoneMaxDBOutput.get(testFreqNo))/20);
         Forklaring: ((DBHvadViVilAfspille - MaxDBOutputForFrekvens) / 20)^10
         */
        return 1.0
    }
    
}


