

import Foundation

class AmpManager {
    
    var maxDBs: Dictionary<Int, Double> = [:]
    
    init() {
        maxDBs = [10000:101.72, 12500:102.43, 14000:103.52, 16000:103.97]
    }
    
    func calculateAmplitudeTesting(inputDB: Double, frequency: Int) -> Double{
        /*
         Math.pow(10,(dbRSPL-phoneMaxDBOutput.get(testFreqNo))/20);
         Forklaring: ((DBHvadViVilAfspille - MaxDBOutputForFrekvens) / 20)^10
         */
        if let maxDB = maxDBs[frequency] {
            return calculateAmplitude(inputDB: inputDB, maxDB: maxDB)
        }
        return 0.0
    }
    
    func calculateAmplitudeCalibration(inputDB: Double, maxDB: Double) -> Double {
        calculateAmplitude(inputDB: inputDB, maxDB: maxDB)
    }
    
    private func calculateAmplitude(inputDB: Double, maxDB: Double) -> Double {
        let calculatedAmp = pow(10, (inputDB - maxDB) / 20)
        return calculatedAmp
    }
    
}
