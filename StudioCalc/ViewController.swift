//
//  ViewController.swift
//  StudioCalc
//
//  Created by Doug Olson on 9/25/16.
//  Copyright © 2016 Doug Olson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var time = 0.0
    var timeArr = [Double]()
    var count = 0
    var timeDiff = 0.0
    var timeMean = 0.0
    var bpm = 0.0
    var noteVals = [1,2,4,8,16,32]
    var clickOn = false
    let noteDefaultColor = UIColor(red: 176/255, green: 228/255, blue: 145/255, alpha: 0.75)
    let noteClickedColor = UIColor(red: 176/255, green: 228/255, blue: 145/255, alpha: 0.0)
    let bgColor = UIColor(red: 152/255, green: 204/255, blue: 191/255, alpha: 1.0)
    let bgColorDark = UIColor(red: 145/255, green: 175/255, blue: 183/255, alpha: 1.0)
    
    
    var timer = Timer()

    @IBOutlet weak var bpmResult: UILabel!
    @IBOutlet weak var delayResult: UILabel!
    @IBOutlet weak var hzResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // reset
    
    func resetState() {
        time = 0.0
        timeArr = [Double]()
        count = 0
        timeDiff = 0.0
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

    }
    
    // Tap Tampo
    @IBAction func buttonTapped(_ sender: AnyObject) {
        
        time = CACurrentMediaTime() // get device time
        timeArr.append(time) // array of time values
        switch count{
            case 0...1:
                timeDiff = 0.0
                bpmResult.text = "..."
            default:
                if (timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]) < 1.5 && clickOn == false   {
                    timeDiff = timeArr[timeArr.count - 1] - timeArr[0]
                    timeMean = timeDiff / Double(count)
                    bpm = round(10 * 60 * Double(count) / timeDiff) / 10
                }
                // startClick after 2 seconds if off
                else if (timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]) >= 1.5 && clickOn == false   {
                    screenFlashClick()
                    clickOn = true
                    }
                // reset after 2 seconds if click is on
                else if (timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]) >= 1.5 && clickOn == true
                {
                    resetState()
                    clickOn = false
                    return
                }
                bpmResult.text = "\(bpm) B.P.M"

            }
        count += 1
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
    

    func screenFlashClick() {
            view.layer.removeAllAnimations()
            UIView.animate(withDuration: timeMean, delay: 0, options: [.allowUserInteraction, .curveEaseInOut, .repeat], animations: {
                self.view.backgroundColor = self.bgColorDark
            }) { (true) in
                self.view.backgroundColor = self.bgColor
        }
    }
    
    
    
    
}
    
    





































