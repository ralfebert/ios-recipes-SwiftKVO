//
//  ViewController.swift
//  SwiftKVO
//
//  Created by Ralf Ebert on 20/02/16.
//  Copyright © 2016 Ralf Ebert. All rights reserved.
//

import UIKit

class CounterModel : NSObject {
    
    dynamic var value = 0
    
    dynamic var messages = [String]()
    
}

class CounterViewController: UIViewController {

    let model = CounterModel()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messagesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBackgroundTask()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.observeModel = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.observeModel = false
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        print("observeValueForKeyPath: \(keyPath) object: \(object)")
        
        if object === model && keyPath == "value" {
            self.label.text = String(model.value)
        }
        if object === model && keyPath == "messages" {
            self.messagesLabel.text = String(model.messages.joinWithSeparator("\n"))
        }
    }
    
    func startBackgroundTask() {
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "changeModel", userInfo: nil, repeats: true)
    }
    
    func changeModel() {
        model.value += 1
        model.messages.append("Hello \(NSDate())")
    }

    var observeModel = false {
        didSet {
            guard observeModel != oldValue else { return }
            
            if observeModel {
                model.addObserver(self, forKeyPath: "value", options: NSKeyValueObservingOptions(), context: nil)
                model.addObserver(self, forKeyPath: "messages", options: NSKeyValueObservingOptions(), context: nil)
            } else {
                model.removeObserver(self, forKeyPath: "value")
                model.removeObserver(self, forKeyPath: "messages")
            }
        }
    }

}

