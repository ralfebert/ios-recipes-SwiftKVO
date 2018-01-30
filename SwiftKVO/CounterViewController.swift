import UIKit

class CounterModel : NSObject {
    
    @objc dynamic var value = 0
    
    @objc dynamic var messages = [String]()
    
}

class CounterViewController: UIViewController {

    let model = CounterModel()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messagesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBackgroundTask()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.observeModel = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.observeModel = false
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        print("observeValue keyPath:\(String(describing: keyPath)) object: \(String(describing: object))")
        
        guard let object = object else { return }
        
        if let model = object as? CounterModel {
            if keyPath == "value" {
                self.label.text = String(model.value)
            }
            if keyPath == "messages" {
                self.messagesLabel.text = String(model.messages.joined(separator: "\n"))
            }
        }
    }
    
    func startBackgroundTask() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeModel), userInfo: nil, repeats: true)
    }
    
    @objc func changeModel() {
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

