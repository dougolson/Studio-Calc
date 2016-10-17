//
//  ViewController.swift
//  StudioCalc
//
//  Created by Doug Olson on 9/25/16.
//  Copyright © 2016 Doug Olson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    var isMuted:Bool = false
//    self.player.volume = 1.0
    
    var currAbsTime : CFAbsoluteTime = 0.0
    var timeArr = [Double]()
    var timeDiffArray = [Double]()
    var medianInterval = 0.0
    var meanInterval = 0.0
    var tapCount = 0
    var timeDiff = 0.0
    var timeMean = 0.0
    var bpm = 0.0
    var bpm2 = 0.0
    var finalBpmInterval = 0.0
    
    var noteVals = [1,2,4,8,16]
    
    var clickOn = false
    var clickTimer = Timer()
    
    let noteDefaultColor = UIColor(red: 176/255, green: 228/255, blue: 145/255, alpha: 0.75)
    let noteClickedColor = UIColor(red: 176/255, green: 228/255, blue: 145/255, alpha: 0.0)
    let bgColor = UIColor(red: 152/255, green: 204/255, blue: 191/255, alpha: 1.0)
    let bgColorDark = UIColor(red: 145/255, green: 175/255, blue: 183/255, alpha: 1.0)

    @IBOutlet weak var bpmResult: UILabel!
    @IBOutlet weak var delayResult: UILabel!
    @IBOutlet weak var hzResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioClick()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // reset
    
    func resetState() {
        currAbsTime = 0.0
        timeArr = []
        timeDiff = 0.0
        timeDiffArray = []
        tapCount = 0
        bpm = 0.0
        bpm = 0.0
        bpmResult.text = "Tempo"
        delayResult.text = "Delay"
        hzResult.text = "Hz"
        for i in noteVals {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.backgroundColor = noteDefaultColor
            }
        }
        view.layer.removeAllAnimations()
        self.clickTimer.invalidate()
    }
    
    //Mean
    
    func mean(_ array: [Double]) -> Double? {
        let total = array.reduce(0, {$0 + $1})
        let mean = total / Double(array.count)
        return mean
    }
    
    // Median
    
    func median(_ values: [Double]) -> Double? {
        let count = Double(values.count)
        if count == 0 { return nil }
        let sorted = values.sorted()//sort(values)
        
        if count.truncatingRemainder(dividingBy: 2) == 0 {
            // Even number of items - return the mean of two middle values
            let leftIndex = Int(count / 2 - 1)
            let leftValue = sorted[leftIndex]
            let rightValue = sorted[leftIndex + 1]
            return (leftValue + rightValue) / 2
        } else {
            // Odd number of items - take the middle item.
            return sorted[Int(count / 2)]
        }
    }
    
    // Tap Tampo
    @IBAction func buttonTapped(_ sender: AnyObject) {
    
        currAbsTime = CACurrentMediaTime() // get device time
        timeArr.append(currAbsTime) // array of time values
        
        switch tapCount{
            case 0:
                bpmResult.text = "..."
            
            default:
                if (timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]) < 1.5 && clickOn == false   {
                    //                    audioClick()
                    timeDiff = timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]
                    timeDiffArray.append(timeDiff)
//                    timeDiffArray = replaceOutliers(timeDiffArray)
                    medianInterval = median(timeDiffArray)!
                    meanInterval = mean(timeDiffArray)!
                    bpm = round(10 * (60 / medianInterval)) / 10
                    bpm2 = round(10 * (60 / meanInterval)) / 10
                    finalBpmInterval = 60 / bpm
                }
                    // startClick after 1.5 seconds if off
                else if (timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]) >= 1.5 && clickOn == false   {
                    screenFlashClick(finalBpmInterval)
                    
                    self.clickTimer = Timer.scheduledTimer(timeInterval: finalBpmInterval, target: self,  selector: #selector(ViewController.audioClick), userInfo: nil, repeats: true)
                    
                    clickOn = true
                }
                    // reset after 2 seconds if click is on
                else if (timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]) >= 1.5 && clickOn == true
                {
                    resetState()
                    clickOn = false
                    return
                }
            }
        bpmResult.text = "MD: \(bpm), MN: \(bpm2)"
        tapCount += 1
    }
    

    // Note Values
    
    @IBAction func noteValClicked(_ sender: UIButton) {
        let delayTime = round(240000.0 / (Double(sender.tag) * bpm))/1000.0
//        currentNoteValue = delayTime
        let frequency = round(100 * bpm * Double(sender.tag) / (4 * 60.0)) / 100
        if bpm > 0 {
            delayResult.text = "\(delayTime) sec"
            hzResult.text = "\(frequency) Hz"
            noteButtonUpdate(tag: sender.tag)
        }
    }
    

    func noteButtonUpdate (tag: Int) {
        for i in noteVals {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.backgroundColor = noteDefaultColor
            }
        }
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.backgroundColor = noteClickedColor
            }
    }
    

  
    func audioClick(){
        if let asset = NSDataAsset(name:"click") {
            
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound
                try player = AVAudioPlayer(data:asset.data, fileTypeHint:"wav")
                // Play the above sound file
                switch clickOn {
                    case false:
                        player.prepareToPlay()
                    case true:
                        player.play()
                    }
                }
            catch let error as NSError {
                print(error.localizedDescription)
                }
            }
        }
        
    
    func screenFlashClick(_ duration: Double) {
            view.layer.removeAllAnimations()
            UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut, .repeat], animations: {
                self.view.backgroundColor = self.bgColorDark
            }) { (true) in
                self.view.backgroundColor = self.bgColor
        }
    }
    
    @IBAction func AudioClickOnOff(_ sender: UIButton) {
        if isMuted == false {
            player.volume = 0.0
            isMuted = true
        } else {
            isMuted = false
        }
        print(player.volume)
    }
    
    
    
}
    
    





































