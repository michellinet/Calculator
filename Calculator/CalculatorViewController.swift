//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Michelline Tran on 3/14/17.
//  Copyright © 2017 Michelline Tran. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatingPointNumber = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(named: "✅") { [unowned self] in
            self.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    var userIsInTheMiddleOfFloatingPointNumber = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." {
            if userIsInTheMiddleOfFloatingPointNumber {
                return
            }
            
            if !userIsInTheMiddleOfTyping {
                digit = "0."
            }
            
            userIsInTheMiddleOfFloatingPointNumber = true
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {             //computed property
        get {
            return Double(display.text!)!
        }
        set {
            if newValue == 0.0 {
                display.text = "0"
            } else {
                display.text = String(newValue)
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
//    var memoryDictionary: Dictionary<String, Double>?
    
    @IBAction func storeMemory(_ sender: Any) {
        brain.memory = [brain.M: displayValue]
        let memory = brain.evaluate(using: brain.memory)
        displayValue = memory.result ?? 0.0
        
        let currentMemory = brain.memory?[brain.M] ?? 0.0
        memoryValue.text = String(describing: currentMemory)
    }
    
    @IBAction func MPressed(_ sender: Any) {
        brain.setOperand(variable: "M")
    }

    @IBOutlet weak var memoryValue: UILabel!
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
                displayValue = result
        }
        
        let currentMemory = brain.memory?[brain.M] ?? 0.0
        memoryValue.text = String(describing: currentMemory)
    }
}
