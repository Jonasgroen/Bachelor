import UIKit
import AudioKit
import AVFoundation

class TestViewController: UIViewController {
    
    @IBOutlet weak var LabelInTest: UILabel!
    @IBOutlet weak var testButton: UIButton!
    
    let osciliator = AKOscillator(waveform:AKTable(.sine))
    let ampManager = AmpManager()
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
    }
    
    func waitRandom(){
        sleep(UInt32.random(in: 2...5))
    }
    
    @IBAction func soundButton(_ sender: Any) {
        if (isTestRunning) {
            if (isAudioOn) {
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
        osciliator.amplitude = ampManager.calculateAmplitudeTesting(inputDB: Double(dB), frequency: Int(freq))
        osciliator.rampDuration = 1
        do{
            try AKManager.stop()
        }
        catch{
            print("AudioKit could not stop")
        }
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
        osciliator.amplitude = 0
        isAudioOn = false
        DispatchQueue.main.async {
            if (!self.isTestRunning) {
                self.LabelInTest.text = "Press the start button to begin the test!"
                self.testButton.setImage(UIImage(named: "startBtn"), for: .normal)
            }
        }
    }
}


