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
    var bpm = 0.0
    var noteVals = [1,2,4,8,16,32]
    let noteDefaultColor = UIColor(red: 176/255, green: 228/255, blue: 145/255, alpha: 0.8)
    let noteClickedColor = UIColor(red: 176/255, green: 228/255, blue: 145/255, alpha: 0.0)
    

    @IBOutlet weak var bpmResult: UILabel!
    @IBOutlet weak var delayResult: UILabel!
    @IBOutlet weak var hzResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetState() {
        time = 0.0
        timeArr = [Double]()
        count = 0
        timeDiff = 0.0
        bpm = 0.0
        bpmResult.text = "Tempo"
        delayResult.text = "Delay"
        hzResult.text = "Hz"
        for var i in noteVals {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.backgroundColor = noteDefaultColor
            }
        }
    }
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        
        time = CACurrentMediaTime() // get device time
        timeArr.append(time) // array of time values
        print(count)
        switch count{
            case 0:
                timeDiff = 0.0
            case 1:
                timeDiff = 0.0
            default:
                timeDiff = timeArr[timeArr.count - 1] - timeArr[0]
                bpm = round(10 * 60 * Double(count) / timeDiff) / 10
                if (timeArr[timeArr.count - 1] - timeArr[timeArr.count - 2]) > 2 {
                    resetState()
                    return
                }
            }
        
        bpmResult.text = "\(bpm) B.P.M"
        
        count += 1

    }
    

    @IBAction func noteValClicked(_ sender: UIButton) {
        let delayTime = round(240000.0 / (Double(sender.tag) * bpm))/1000.0
        let frequency = round(100 * bpm * Double(sender.tag) / (4 * 60.0)) / 100
        if bpm > 0 {
            delayResult.text = "\(delayTime) sec"
            hzResult.text = "\(frequency) Hz"
            noteButtonUpdate(tag: sender.tag)
        }
    }
    
    func noteButtonUpdate (tag: Int) {
        for var i in noteVals {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.backgroundColor = noteDefaultColor
                }
            }
            if let button = self.view.viewWithTag(tag) as? UIButton {
                button.backgroundColor = noteClickedColor
            }
        }
}





































