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
    var maxFreq = 0
    var profile = Profile()
    
    
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func soundButton(_ sender: Any) {
        if (isTestRunning) {
            if (isAudioOn) {
                maxFreq = currentFreq
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
    
}
