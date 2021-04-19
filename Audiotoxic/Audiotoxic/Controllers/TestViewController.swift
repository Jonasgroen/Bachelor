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
    var heardAt40 = false
    
    
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
                if(currentdB == 40){
                    heardAt40 = true
                }
            }
        } else {
            isTestRunning = true
            LabelInTest.text = NSLocalizedString("test.test-running-button", tableName: "InternalLocalizedStrings", comment: "")
            testButton.setImage(UIImage(named: "stopBtn"), for: .normal)
            improvedAlgorithm(leftEar: true)
        }
    }
    
    func improvedAlgorithm(leftEar: Bool){
        //TO-DO:
        //Make it so that if they can hear the sound at 40dB, it will not play at 80dB
        // - Done
        //Make it recall the algorithm on the right ear
        // - Done
        // - Need to change the button back (as it does at the end of createTone
        //Make it save both ears
        // - In progress
        queue.async {
            self.waitRandom()
            self.createTone(freq: 10000, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            if(!self.heardAt40){
                self.createTone(freq: 10000, dB: 80, isLeftEar: leftEar)
                self.waitRandom()
            } else {
                self.heardAt40 = false
            }
            self.createTone(freq: 12500, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            if(!self.heardAt40){
                self.createTone(freq: 12500, dB: 80, isLeftEar: leftEar)
                self.waitRandom()
            } else {
                self.heardAt40 = false
            }
            self.createTone(freq: 14000, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            if(!self.heardAt40){
                self.createTone(freq: 14000, dB: 80, isLeftEar: leftEar)
                self.waitRandom()
            } else {
                self.heardAt40 = false
            }
            self.createTone(freq: 16000, dB: 40, isLeftEar: leftEar)
            self.waitRandom()
            if(!self.heardAt40){
                self.createTone(freq: 16000, dB: 80, isLeftEar: leftEar)
                self.waitRandom()
            } else {
                self.heardAt40 = false
            }
            let reading = Reading(frequency: self.maxFreq, leftEar: leftEar)
            print(reading.maxFrequency)
            print(reading.date)
            print("is left ear: " + leftEar.description)
            if self.profile.okToSave(date: reading.date, freq: reading.maxFrequency, leftEar: leftEar){
                self.profile.results.append(reading)
                self.profile.saveProfile()
                }
            if(leftEar){
                self.improvedAlgorithm(leftEar: false)
            } else {
                self.isTestRunning = false
                DispatchQueue.main.async {
                    if (!self.isTestRunning) {
                        self.LabelInTest.text = "Press the start button to begin the test!"
                        self.testButton.setImage(UIImage(named: "startBtn"), for: .normal)
                    }
                }
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
        DispatchQueue.main.async {
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


